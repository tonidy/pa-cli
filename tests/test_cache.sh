#!/bin/bash
#
# Comprehensive test suite for pa cache functionality
# Tests cache operations, expiration, security, and integration

set -e

# Test configuration
TEST_DIR="$(mktemp -d)"
TEST_PA_DIR="$TEST_DIR/pa"
TEST_CACHE_TIMEOUT=5  # Short timeout for testing

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Setup test environment
setup_test_env() {
    export PA_DIR="$TEST_PA_DIR"
    export PA_CACHE_TIMEOUT="$TEST_CACHE_TIMEOUT"
    export PA_NOGIT=1  # Disable git for testing
    
    mkdir -p "$TEST_PA_DIR/passwords"
    
    # Create test identity and recipients files
    echo "# Test identity file" > "$TEST_PA_DIR/identities"
    echo "# Test recipients file" > "$TEST_PA_DIR/recipients"
    
    # Create a test password file
    echo "test-password-123" > "$TEST_PA_DIR/passwords/test.age"
}

# Cleanup test environment
cleanup_test_env() {
    rm -rf "$TEST_DIR" 2>/dev/null || true
}

# Test helper functions
log_test() {
    printf "${YELLOW}[TEST]${NC} %s\n" "$1"
    TESTS_RUN=$((TESTS_RUN + 1))
}

log_pass() {
    printf "${GREEN}[PASS]${NC} %s\n" "$1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

log_fail() {
    printf "${RED}[FAIL]${NC} %s\n" "$1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

# Extract cache functions from pa script for testing
extract_cache_functions() {
    # Extract only the cache-related functions from pa script
    sed -n '/^# ============================================================================/,/^# Decrypt file with automatic passphrase handling/p' ../pa | head -n -1 > /tmp/cache_functions.sh
    source /tmp/cache_functions.sh
}

# Test cache initialization
test_cache_init() {
    log_test "Cache initialization"

    # Extract and source cache functions
    extract_cache_functions

    # Test cache initialization
    if cache_init; then
        log_pass "Cache initialization successful"
    else
        log_fail "Cache initialization failed"
        return 1
    fi

    # Check if cache directory was created
    if [ -d "$PA_CACHE_DIR" ]; then
        log_pass "Cache directory created: $PA_CACHE_DIR"
    else
        log_fail "Cache directory not created"
        return 1
    fi
}

# Test basic cache operations
test_basic_cache_ops() {
    log_test "Basic cache operations"

    # Extract and source cache functions
    extract_cache_functions

    local test_file="$TEST_PA_DIR/passwords/test.age"
    local test_data="test-cached-data-123"

    # Test cache set
    if printf '%s' "$test_data" | cache_set "$test_file"; then
        log_pass "Cache set operation successful"
    else
        log_fail "Cache set operation failed"
        return 1
    fi

    # Test cache get
    local retrieved_data=$(cache_get "$test_file")
    if [ "$retrieved_data" = "$test_data" ]; then
        log_pass "Cache get operation successful"
    else
        log_fail "Cache get operation failed: expected '$test_data', got '$retrieved_data'"
        return 1
    fi
}

# Test cache expiration
test_cache_expiration() {
    log_test "Cache expiration"

    # Extract and source cache functions
    extract_cache_functions

    local test_file="$TEST_PA_DIR/passwords/expire_test.age"
    local test_data="expiring-data-456"

    # Set data in cache
    printf '%s' "$test_data" | cache_set "$test_file"

    # Verify data is initially available
    local retrieved_data=$(cache_get "$test_file")
    if [ "$retrieved_data" = "$test_data" ]; then
        log_pass "Data initially cached correctly"
    else
        log_fail "Data not cached correctly initially"
        return 1
    fi

    # Wait for expiration (timeout + 1 second)
    sleep $((TEST_CACHE_TIMEOUT + 1))

    # Try to retrieve expired data
    if cache_get "$test_file" >/dev/null 2>&1; then
        log_fail "Expired data was still returned from cache"
        return 1
    else
        log_pass "Expired data correctly rejected from cache"
    fi
}

# Test cache management commands
test_cache_commands() {
    log_test "Cache management commands"

    # Test cache stats command using the actual pa script
    if echo "n" | PA_NOGIT=1 ../pa cache stats >/dev/null 2>&1; then
        log_pass "Cache stats command works"
    else
        log_fail "Cache stats command failed"
        return 1
    fi

    # Test cache functions directly
    extract_cache_functions

    # Test cache clear command (non-interactive)
    export PA_CACHE_TIMEOUT=1  # Very short timeout
    printf '%s' "test-data" | cache_set "$TEST_PA_DIR/passwords/clear_test.age"

    if cache_clear_all; then
        log_pass "Cache clear command works"
    else
        log_fail "Cache clear command failed"
        return 1
    fi
}

# Run all tests
run_all_tests() {
    printf "${YELLOW}Starting pa cache test suite...${NC}\n"
    
    setup_test_env
    
    # Run individual tests
    test_cache_init || true
    test_basic_cache_ops || true
    test_cache_expiration || true
    test_cache_commands || true
    
    cleanup_test_env
    
    # Print summary
    printf "\n${YELLOW}Test Summary:${NC}\n"
    printf "Tests run: %d\n" "$TESTS_RUN"
    printf "${GREEN}Passed: %d${NC}\n" "$TESTS_PASSED"
    printf "${RED}Failed: %d${NC}\n" "$TESTS_FAILED"
    
    if [ "$TESTS_FAILED" -eq 0 ]; then
        printf "\n${GREEN}All tests passed!${NC}\n"
        exit 0
    else
        printf "\n${RED}Some tests failed!${NC}\n"
        exit 1
    fi
}

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    run_all_tests
fi
