angular.module("custSupportTickets")
	.service("Auth", ["$rootScope", "$state", "$auth", function($rootScope, $state, $auth){
		// set this for nested calls
		var self = this;

		/* 
		handle login and logout
		multiple actions can log a user in our out
		ensure all actions are handled the same way (as necessary)
		*/
		// login: user
		self._login = function(user, redirect){
			// set current user
			self.setCurrentUser(user);

			// flag required redirects
			redirect = (redirect === false ? false : true); // by default redirect to tickets
			if (redirect){
				// kick back to login
				$state.go("loggedIn.tickets");
			}
		};

		// logout
		self._logout = function(redirect){
			// unset current user
			self.destroyCurrentUser();

			// flag required redirects
			redirect = (redirect === false ? false : true); // by default redirect back to login
			if (redirect){
				// kick back to login
				$state.go("login");
			}
		}

		/*
		handle current user data for app
		*/
		// initialize current user
		$rootScope.currentUser = {
			isLoggedIn: false,
			isAdmin: false,
			user: null
		};

		// set current user from data auth user data
		self.setCurrentUser = function(userData){
			$rootScope.currentUser.isLoggedIn = userData.signedIn;
			$rootScope.currentUser.isAdmin = userData.admin;
			$rootScope.currentUser.user = userData;
		}

		// unset current user
		self.destroyCurrentUser = function(){
			$rootScope.currentUser.isLoggedIn = false;
			$rootScope.currentUser.isAdmin = false;
			$rootScope.currentUser.user = null;
		}

		/*
		event handling for authentication
		(signup handled inside controller for security)
		*/
		// successful authentication
		// correct login
		$rootScope.$on("auth:login-success", function(ev, user){
			self._login(user);
		});
		// correct token
		$rootScope.$on("auth:validation-success", function(ev, user){
			self._login(user, false);
		})
		// error authentication
		// incorrect login
		$rootScope.$on("auth:login-error", function(ev, reason){
			self._logout(false); // send logout without redirect
		});
		// incorrect token
		$rootScope.$on("auth:invalid", function(ev, reason){
			self._logout();
		});
		// misc error
		$rootScope.$on("auth:validation-error", function(ev, reason){
			self._logout();
		});

		/*
		handle scoped authorization requests from controller
		controller is in charge of sending correct submission data
		controller is in charge of sending object to keep track of errors
		*/
		/* TODO: handle error messages as root scoped flash messages of app */
		// authorize login
		// loginData: { email: string, password: string }
		// errorData: { errors: boolean, messages: [string] }
		self.logIn = function(loginData, errorData){
			$auth.submitLogin(loginData)
				.then(function(response){
					// clear error messages on succesful login
					errorData.errors = false;
					errorData.messages = [];
				})
				.catch(function(response){
					// display error messages from failed login
					errorData.errors = true;
					errorData.messages = response.errors;
				});
		}

		// authorize signup
		// signupData: { email: string, username: string, password: string }
		// errorData: { errors: boolean, message: [string] }
		self.signUp = function(signupData, errorData){
			$auth.submitRegistration(signupData)
				.then(function(response){
					// clear error messages on succesful signup
					errorData.errors = false;
					errorData.messages = [];
				})
				.catch(function(response){
					// display error messages from failed login
					errorData.errors = true;
					errorData.messages = response.data.errors.full_messages;
				});
		}

		/*
		handle user logouts
		(user logouts happen through root)
		*/
		// event handling
		$rootScope.$on("auth:logout-success", function(ev){
			self._logout();
		});
		$rootScope.$on("auth:logout-error", function(ev, reason){
			self._logout();
		});
		// expired session (handle as log out)
		$rootScope.$on("auth:session-expired", function(ev){
			self._logout();
		});

		// user logout
		$rootScope.logOut = function(){
			$auth.signOut();
		}
	}]);