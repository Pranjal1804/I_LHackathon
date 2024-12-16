const Travel = artifacts.require("Travel");

contract("Travel", (accounts) => {
  const [owner, admin, user] = accounts;

  beforeEach(async () => {
    this.travel = await Travel.new();
  });

  describe("Routes", () => {
    it("Should add a route", async () => {
      await this.travel.addRoute(
        "Route 1",
        "image_url",
        "Category",
        "Description",
        { from: owner }
      );
      const route = await this.travel.getRoute(1);
      assert.equal(route.name, "Route 1");
    });

    it("Should update a route", async () => {
      await this.travel.addRoute(
        "Route 1",
        "image_url",
        "Category",
        "Description",
        { from: owner }
      );
      await this.travel.updateRoute(
        1,
        "Updated Route",
        "new_image_url",
        "New Category",
        "New Description",
        { from: owner }
      );
      const route = await this.travel.getRoute(1);
      assert.equal(route.name, "Updated Route");
    });

    it("Should delete a route", async () => {
      await this.travel.addRoute(
        "Route 1",
        "image_url",
        "Category",
        "Description",
        { from: owner }
      );
      await this.travel.deleteRoute(1, { from: owner });
      const route = await this.travel.getRoute(1);
      assert.isTrue(route.deleted);
    });
  });

  describe("Timeslots", () => {
    it("Should add a timeslot", async () => {
      await this.travel.addRoute(
        "Route 1",
        "image_url",
        "Category",
        "Description",
        { from: owner }
      );
      await this.travel.addTimeslot(
        1,
        [100],
        [Date.now() + 1000],
        [Date.now() + 2000],
        [50],
        [1],
        { from: owner }
      );
      const timeslot = await this.travel.getTimeSlot(1);
      assert.equal(timeslot.routeId, 1);
    });

    it("Should delete a timeslot", async () => {
      await this.travel.addRoute(
        "Route 1",
        "image_url",
        "Category",
        "Description",
        { from: owner }
      );
      await this.travel.addTimeslot(
        1,
        [100],
        [Date.now() + 1000],
        [Date.now() + 2000],
        [50],
        [1],
        { from: owner }
      );
      await this.travel.deleteTimeSlot(1, 1, { from: owner });
      const timeslot = await this.travel.getTimeSlot(1);
      assert.isTrue(timeslot.deleted);
    });
  });

  describe("Tickets", () => {
    it("Should buy a ticket", async () => {
      await this.travel.addRoute(
        "Route 1",
        "image_url",
        "Category",
        "Description",
        { from: owner }
      );
      await this.travel.addTimeslot(
        1,
        [100],
        [Date.now() + 1000],
        [Date.now() + 2000],
        [50],
        [1],
        { from: owner }
      );
      await this.travel.buyTicket(1, 1, 1, { from: user, value: 100 });
      const holders = await this.travel.getRouteTicketHolders(1, 1);
      assert.include(holders, user);
    });
  });
});
