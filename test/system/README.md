# Integration Tests for Solo Startup Coach

This directory contains comprehensive integration tests for the Solo Startup Coach application. These tests simulate real user interactions and verify that all components work together correctly.

## Test Categories

### 1. Authentication Flow Tests (`authentication_flow_test.rb`)
Tests the complete user authentication journey:
- User registration with valid/invalid credentials
- User login/logout functionality
- Password validation and security requirements
- Session management and timeout handling
- Account lockout after failed attempts
- Password reset flow

### 2. Startup Tips Management Tests (`startup_tips_management_test.rb`)
Tests the core startup tips functionality:
- Creating, reading, updating, and deleting tips
- Content validation and sanitization
- Search and filtering capabilities
- Pagination for large datasets
- Video generation from tips
- XSS protection and content security

### 3. Video Generation Flow Tests (`video_generation_flow_test.rb`)
Tests the video generation and management workflow:
- Video generation from startup tips
- Job status tracking and progress monitoring
- Video metadata management
- YouTube upload functionality
- Error handling and retry mechanisms
- Queue monitoring and job management

### 4. Dashboard and Analytics Tests (`dashboard_and_analytics_test.rb`)
Tests the dashboard and analytics features:
- Dashboard overview and statistics
- Data visualization and charts
- Performance metrics and system health
- Activity tracking and user behavior
- Export functionality
- Real-time data updates

### 5. API Integration Tests (`api_integration_test.rb`)
Tests the API endpoints and integration:
- API authentication and authorization
- CRUD operations via API
- Rate limiting and security
- Error handling and validation
- Pagination and filtering
- CORS and cross-origin requests

### 6. Error Handling and Edge Cases Tests (`error_handling_and_edge_cases_test.rb`)
Tests system resilience and error scenarios:
- Network connectivity issues
- Server errors and timeouts
- Invalid data handling
- Concurrent user actions
- Large dataset performance
- Browser compatibility
- Memory pressure handling

## Running the Tests

### Run All Integration Tests
```bash
bin/test_integration
```

### Run Individual Test Files
```bash
# Authentication tests
bin/rails test test/system/authentication_flow_test.rb

# Startup tips tests
bin/rails test test/system/startup_tips_management_test.rb

# Video generation tests
bin/rails test test/system/video_generation_flow_test.rb

# Dashboard tests
bin/rails test test/system/dashboard_and_analytics_test.rb

# API tests
bin/rails test test/system/api_integration_test.rb

# Error handling tests
bin/rails test test/system/error_handling_and_edge_cases_test.rb
```

### Run Specific Test Methods
```bash
# Run a specific test method
bin/rails test test/system/authentication_flow_test.rb -n test_user_can_sign_up_with_valid_credentials
```

## Test Setup

### Prerequisites
- Rails application running in test environment
- Database configured for testing
- Chrome/Chromium browser for system tests
- Redis running for background job testing

### Test Data
The tests use fixtures defined in `test/fixtures/`:
- `users.yml` - Test user accounts
- `startup_tips.yml` - Sample startup tips
- `videos.yml` - Sample video records

### Test Helpers
The tests include helper methods in `test/test_helper.rb`:
- `sign_in_user(user)` - Sign in a specific user
- `create_and_sign_in_user(email, password)` - Create and sign in a new user

## Test Coverage

These integration tests cover:

### User Flows
- Complete user registration and onboarding
- Startup tip creation and management
- Video generation and upload workflow
- Dashboard usage and analytics
- API consumption and integration

### Security
- Authentication and authorization
- Input validation and sanitization
- XSS protection
- CSRF protection
- Rate limiting

### Performance
- Large dataset handling
- Concurrent user actions
- Memory usage optimization
- Response time validation

### Error Scenarios
- Network failures
- Server errors
- Invalid user input
- Database connection issues
- Browser compatibility

### Edge Cases
- Special characters in content
- Malformed URLs
- Duplicate content handling
- Session timeout scenarios
- Browser navigation

## Continuous Integration

These tests are designed to run in CI/CD pipelines:
- Headless browser testing
- Parallel test execution
- Comprehensive error reporting
- Fast feedback loops

## Maintenance

### Adding New Tests
1. Create a new test file in `test/system/`
2. Extend `ApplicationSystemTestCase`
3. Use existing fixtures or create new ones
4. Follow the naming convention: `test_descriptive_test_name`

### Updating Tests
- Keep tests focused on user behavior, not implementation details
- Use descriptive test names that explain the scenario
- Maintain test data in fixtures
- Update tests when UI changes

### Debugging Tests
- Use `save_and_open_page` to inspect the page state
- Add `puts` statements for debugging
- Check browser console for JavaScript errors
- Review test logs for detailed error information

## Best Practices

1. **Test User Behavior**: Focus on what users do, not how the code works
2. **Keep Tests Independent**: Each test should be able to run in isolation
3. **Use Descriptive Names**: Test names should clearly describe the scenario
4. **Clean Up After Tests**: Ensure tests don't leave data that affects other tests
5. **Test Error Scenarios**: Don't just test happy paths
6. **Maintain Test Data**: Keep fixtures up to date with model changes
7. **Run Tests Regularly**: Integrate tests into your development workflow 