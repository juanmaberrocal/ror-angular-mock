/*
tickets controller
handle actions for:
 - C: create ticket
 - R: view tickets
 - U: update ticket
 - D: destroy ticket
*/
// index
angular.module("custSupportTickets")
	.controller("ticketsCtrl", ["$scope", "$window", "currRoute", "TicketsResource", function($scope, $window, currRoute, TicketsResource){
		// load tickets
		$scope.tickets = TicketsResource.query();

		// redirect to 
		$scope.viewTicket = function(id){
			currRoute.goTo("loggedIn.showTicket", { id: id })
		}

		// destroy ticket
		$scope.destroyTicket = function(ev, indx, id){
			// pevent redirect from row click
			ev.stopPropagation();

			// display confirmation popup to ensure action
			var deleteConfirm = $window.confirm("Are you sure you wish to delete this ticket?");
			if (deleteConfirm){
				// delete ticket if confirmed
				TicketsResource.destroy({ id: id }, function(success){
					// success handling for ticket deletion
					// remove ticket from $scope.tickets
					$scope.tickets.splice(indx, 1);
				}, function(error){
					// error handling (error.data.errors => error messages)
					alert(error.data.errors)
				});
			}
		}
	}]);

// show
angular.module("custSupportTickets")
	.controller("showTicketCtrl", ["$scope", "$window", "currRoute", "TicketsResource", function($scope, $window, currRoute, TicketsResource){
		// load record
		var ticketId = currRoute.getCurrState().params.id;
		$scope.ticket = TicketsResource.read({ id: ticketId });

		
			// close ticket
			$scope.closeTicket = function(){
				// display confirmation popup to ensure action
				var closeConfirm = $window.confirm("Are you sure you wish to close this ticket?");
				if (closeConfirm){
					// close ticket if action confirmed
					TicketsResource.close({ id: $scope.ticket.id }, function(success){
						// success handling after status update
						$scope.ticket = success // set ticket as updated return
					}, function(error){
						// error handling (error.data.errors => error messages)
						alert(error.data.errors);
					});
				}
			}
	}]);

// new
angular.module("custSupportTickets")
	.controller("newTicketCtrl", ["$scope", "currRoute", "TicketsResource", function($scope, currRoute, TicketsResource){
		// load available dropdown values
		$scope.ticketCategories = TicketsResource.categories();
		$scope.ticketStatuses = TicketsResource.statuses();

		// initialize blank record
		$scope.ticket = {};

		// set init category on ticket
		$scope.ticketCategories.$promise.then(function(res){ $scope.ticket.category = res[0] });

		// set init status on ticket
		$scope.ticketStatuses.$promise.then(function(res){ $scope.ticket.status = res[0] });

		/*
		ticket submission handler
		*/
		// handle form errors
		$scope.ticketErrors = {
			errors: false,
			messages: {} // handle as hash due to server response on error
		}

		// handle form submission
		$scope.ticketSubmit = function(){
			TicketsResource.create($scope.ticket, function(success){
				// success handling after create
				// remove errors
				$scope.ticketErrors.errors = false;
				$scope.ticketErrors.messages = {};

				// redirect to ticket dashboard
				currRoute.goTo("loggedIn.tickets");
			}, function(error){
				// error handling from server
				// add errors
				$scope.ticketErrors.errors = true;
				$scope.ticketErrors.messages = error.data.errors;
			});
		}
	}]);

// edit
angular.module("custSupportTickets")
	.controller("editTicketCtrl", ["$scope", "currRoute", "TicketsResource", function($scope, currRoute, TicketsResource){
		// load available dropdown values
		$scope.ticketCategories = TicketsResource.categories();
		$scope.ticketStatuses = TicketsResource.statuses();

		// load record
		var ticketId = currRoute.getCurrState().params.id;
		$scope.ticket = TicketsResource.read({ id: ticketId });

		/*
		ticket submission handler
		*/
		// handle form errors
		$scope.ticketErrors = {
			errors: false,
			messages: {} // handle as hash due to server response on error
		}

		// handle form submission
		$scope.ticketSubmit = function(){
			TicketsResource.update($scope.ticket, function(success){
				// success handling after create
				// remove errors
				$scope.ticketErrors.errors = false;
				$scope.ticketErrors.messages = {};

				// redirect to ticket dashboard
				currRoute.goTo("loggedIn.showTicket", { id: success.id });
			}, function(error){
				// error handling from server
				// add errors
				$scope.ticketErrors.errors = true;
				$scope.ticketErrors.messages = error.data.errors;
			});
		}
	}]);

// report
angular.module("custSupportTickets")
	.controller("ticketsReportCtrl", ["$scope", "$filter", "TicketsResource", function($scope, $filter, TicketsResource){
		// set display for time frame of report
		$scope.dateToday = new Date();
		$scope.dateStart = new Date().setDate($scope.dateToday.getDate() - 30)

		// load tickets
		$scope.tickets = TicketsResource.report();

		// build pdf once data has loaded
		$scope.tickets.$promise.then(function(){
			html2canvas(document.getElementById("ticketsReport"), {
				onrendered: function(canvas){
					var data = canvas.toDataURL();
					var docDefinition = {
						content: [{
							image: data,
							width: 500
						}]
					};

					// download pdf when ready
					var reportPdfName = "Ticket Report - " + $filter("date")($scope.dateStart, "yyyyMMdd") + "-" + $filter("date")($scope.dateToday, "yyyyMMdd")
					pdfMake.createPdf(docDefinition).download(reportPdfName + ".pdf")
				}
			});
		});
	}]);