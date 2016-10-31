angular.module("custSupportTickets")
	.factory("UsersResource", ["$resource", function($resource){
		return $resource("/api/v1/users/:id", { id: "@id" }, {
			// index query all
			query: { method: "GET", isArray: true },
			// CRUD
			create: { method: "POST" },
			read: { method: "GET" },
			update: { method: "PUT" },
			destroy: { method: "DELETE" },
			// custom
			// close tickets (update status)
			toggle_admin: { method: "POST", url: "/api/v1/users/:id/toggle_admin" }
		});
	}])