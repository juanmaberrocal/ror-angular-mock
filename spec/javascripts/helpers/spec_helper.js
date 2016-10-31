//= require angular-mocks/angular-mocks

// load application
beforeEach(module("custSupportTickets"));

// ng-token-auth configs
// beforeEach(module("ng-token-auth", function(_$authProvider_, _$locationProvider_, $provide){
// 	$authProvider = _$authProvider_;
// 	$locationProvider = _$locationProvider_;
// 	$authProvider.configure({
// 		validateOnPageLoad: false
// 	});
// 	return false;
// }))

// init controller
var $controller, $http, $auth, $state, $location;

// set valid user defaults for authentication
var validUser = {
	id: 1,
	email: "user@test.com",
	username: "user"
}

// 
beforeEach(inject(function(_$controller_, _$httpBackend_, _$auth_, _$state_, _$location_){
	$controller = _$controller_;
	$http = _$httpBackend_;
	$auth = _$auth_;
	$state = _$state_;
	$location = _$location_;

	// mimic user login
	$http.expectPOST("/auth/sign_in").respond(201, { success: true, data: validUser });
	$auth.submitLogin({ email:  validUser.email, password: "password" })
}));

// destroy login after each test
// afterEach(function(){
// 	$http.verifyNoOutstandingExpectation();
//   	$http.verifyNoOutstandingRequest();
//   	$auth.deleteData('auth_headers');
//   	$auth.deleteData('currentConfigName');
//   	$auth.destroy();
// })