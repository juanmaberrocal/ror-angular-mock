angular.module("custSupportTickets")
	.factory("TicketsResource", ["$resource", function($resource){
		return $resource("/api/v1/tickets/:id", { id: "@id" }, {
			// index query all
			query: { method: "GET", isArray: true },
			// CRUD
			create: { method: "POST" },
			read: { method: "GET" },
			update: { method: "PUT" },
			destroy: { method: "DELETE" },
			// custom
			// close tickets (update status)
			close: { method: "POST", url: "/api/v1/tickets/:id/close" },
			// load closed tickets for report
			report: { method: "GET", isArray: true, url: "/api/v1/tickets/report" },
			// load options from server
			statuses: { method: "GET", isArray: true, url: "/api/v1/tickets/statuses" },
			categories: { method: "GET", isArray: true, url: "/api/v1/tickets/categories" }
		});
	}])