describe("Tickets", function (){
  
  // define vars
  var $scope, controller; 

  describe("index", function(){
    // init configs
    beforeEach(function(){
      $scope = {};
      controller = $controller("ticketsCtrl", { $scope: $scope });

      // set tickets
      tickets = [
        { id: 1, title: "Spec Ticket 1", category: "Bug", status: "Open", description: "Open Spec Testing Ticket" },
        { id: 2, title: "Spec Ticket 2", category: "Bug", status: "Closed", description: "Closed Spec Testing Ticket" }
      ];

      // psuedo get tickets query
      $http.whenGET("/api/v1/tickets").respond(200, tickets);
      $http.flush();
    });

    // ensure tickets get queried
    it("Resource.query()", function(){
      expect($scope.tickets.length).toEqual(2);
    });

    // ensure on viewTicket redirect to record
    // it("$scope.viewTicket", function(){
    //   $scope.viewTicket(tickets[0].id);
    //   expect($state.current.name).toBe("/tickets/1")
    // });
  });

  describe("show", function(){
    // init configs
    beforeEach(function(){
      $scope = {};
      controller = $controller("showTicketCtrl", { $scope: $scope });

      // set tickets
      ticket = [
        { id: 1, title: "Spec Ticket 1", category: "Bug", status: "Open", description: "Open Spec Testing Ticket" }
      ];

      // psuedo get tickets query
      $http.whenGET("/api/v1/tickets").respond(200, ticket);
      $http.flush();
    });

    // ensure tickets get queried
    // it("Resource.read()", function(){
    //   expect($scope.ticket.length).toEqual(1);
    // });
  });

});