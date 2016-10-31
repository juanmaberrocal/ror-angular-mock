angular.module("custSupportTickets", ["ui.router", "ngResource", "ng-token-auth", "templates"])
	// configure routes
	.config([
		"$stateProvider",
		"$urlRouterProvider",
		"$authProvider",
		function($stateProvider, $urlRouterProvider, $authProvider){
			// define authentication API
			$authProvider
				.configure({
					apiUrl: ""
				});

			// define states
			$stateProvider
				.state("login", { // root login page
					url: "/login",
					templateUrl: "_login.html",
					controller: "loginCtrl"
				})
				// authenticated states
				.state("loggedIn", {
					abstract: true,
					template: "<ui-view/>", // wrapper for child authenticated views
					resolve: {
						auth: function($auth){
							return $auth.validateUser();
						}
					}
				})
				/* 
				tickets routes
				crud:
				 - index
				 - show
				 - form (new|edit)
				*/
				.state("loggedIn.tickets", { // index tickets
					url: "/tickets",
					templateUrl: "tickets/_index.html",
					controller: "ticketsCtrl"
				})
				.state("loggedIn.newTicket", { // new ticket
					url: "/tickets/new",
					templateUrl: "tickets/_form.html",
					controller: "newTicketCtrl"
				})
				.state("loggedIn.showTicket", { // show ticket
					url: "/tickets/:id",
					templateUrl: "tickets/_show.html",
					controller: "showTicketCtrl"
				})
				.state("loggedIn.editTicket", { // edit ticket
					url: "/tickets/:id/edit",
					templateUrl: "tickets/_form.html",
					controller: "editTicketCtrl"
				})
				// extra
				.state("loggedIn.reportTickets", { // build report for tickets
					url: "/report",
					templateUrl: "tickets/_report.html",
					controller: "ticketsReportCtrl"
				})
				/*
				user routes
				rd:
			 	 - index
				 - show
				*/
				.state("loggedIn.users", {
					url: "/users",
					templateUrl: "users/_index.html",
					controller: "usersCtrl"
				})
				.state("loggedIn.showUser", {
					url: "/users/:id",
					templateUrl: "users/_show.html",
					controller: "showUserCtrl"
				});

			// redirect to login
			$urlRouterProvider.otherwise("/login");
		}
	])
	.run(["Auth", "currRoute", function(Auth, currRoute){
		// init services
	}]);