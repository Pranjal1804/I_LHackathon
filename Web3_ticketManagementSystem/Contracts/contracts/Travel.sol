//SPDX-License-Identifier:MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";


contract DappTravel is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _totalRoutes;
    Counters.Counter private _totalTickets;
    Counters.Counter private _totalSlots;

    struct RouteStruct {
        uint256 id;
        string name;
        string imageUrl;
        string category;
        string description;
        uint256 timestamp;
        bool deleted;
    }

    struct TicketStruct {
        uint256 id;
        uint256 routeId;
        address owner;
        uint256 cost;
        uint256 timestamp;
        uint256 day;
        bool refunded;
    }

    struct TimeSlotStruct {
        uint256 id;
        uint256 routeId;
        uint256 ticketCost;
        uint256 startTime;
        uint256 endTime;
        uint256 capacity;
        uint256 seats;
        bool deleted;
        bool completed;
        uint256 day;
        uint256 balance;
    }

    event Action(string actionType);

    uint256 public balance;
    mapping(uint256 => bool) routeExists;
    mapping(uint256 => RouteStruct) routes;
    mapping(uint256 => TimeSlotStruct) routeTimeSlot;
    mapping(uint256 => mapping(uint256 => address[])) ticketHolder;

    function addRoute(
        string memory name,
        string memory imageUrl,
        string memory category,
        string memory description
    ) public onlyOwner {
        require(bytes(name).length > 0, "Route name required");
        require(bytes(imageUrl).length > 0, "Route image url required");
        require(bytes(category).length > 0, "Route category required");
        require(bytes(description).length > 0, "Route description required");

        _totalRoutes.increment();
        RouteStruct memory route;

        route.id = _totalRoutes.current();
        route.name = name;
        route.imageUrl = imageUrl;
        route.category = category;
        route.description = description;
        route.timestamp = currentTime();

        routes[route.id] = route;
        routeExists[route.id] = true;

        emit Action("Route added successfully");
    }

    function updateRoute(
        uint256 routeId,
        string memory name,
        string memory imageUrl,
        string memory category,
        string memory description
    ) public onlyOwner {
        require(routeExists[routeId], "Route doesn't exist!");
        require(bytes(name).length > 0, "Route name required");
        require(bytes(imageUrl).length > 0, "Route image URL required");
        require(bytes(category).length > 0, "Route category required");
        require(bytes(description).length > 0, "Route description required");

        for (uint256 slotId = 1; slotId <= _totalSlots.current(); slotId++) {
            address[] storage holders = ticketHolder[routeId][slotId];
            require(
                holders.length == 0,
                "Cannot update route with purchased tickets"
            );
        }

        routes[routeId].name = name;
        routes[routeId].imageUrl = imageUrl;
        routes[routeId].category = category;
        routes[routeId].description = description;

        emit Action("Route updated successfully");
    }

    function deleteRoute(uint256 routeId) public onlyOwner {
        require(routeExists[routeId], "Route doesn't exist!");

        for (uint256 slotId = 1; slotId <= _totalSlots.current(); slotId++) {
            address[] memory holders = ticketHolder[routeId][slotId];
            require(
                holders.length == 0,
                "Cannot delete route with purchased tickets"
            );
        }

        routes[routeId].deleted = true;
        routeExists[routeId] = false;
    }

    function getRoutes() public view returns (RouteStruct[] memory Routes) {
        uint256 totalRoutes;
        for (uint256 i = 1; i <= _totalRoutes.current(); i++) {
            if (!routes[i].deleted) totalRoutes++;
        }

        Routes = new RouteStruct[](totalRoutes);

        uint256 j = 0;
        for (uint256 i = 1; i <= _totalRoutes.current(); i++) {
            if (!routes[i].deleted) {
                Routes[j] = routes[i];
                j++;
            }
        }
    }

    function getRoute(uint256 id) public view returns (RouteStruct memory) {
        return routes[id];
    }

    function addTimeslot(
        uint256 routeId,
        uint256[] memory ticketCosts,
        uint256[] memory startTimes,
        uint256[] memory endTimes,
        uint256[] memory capacities,
        uint256[] memory travelDays
    ) public onlyOwner {
        require(routeExists[routeId], "Route not found");
        require(ticketCosts.length > 0, "Tickets cost must not be empty");
        require(capacities.length > 0, "Capacities must not be empty");
        require(startTimes.length > 0, "Start times cost must not be empty");
        require(endTimes.length > 0, "End times cost must not be empty");
        require(travelDays.length > 0, "Travel days must not be empty");
        require(
            ticketCosts.length == travelDays.length &&
                travelDays.length == capacities.length &&
                capacities.length == startTimes.length &&
                startTimes.length == endTimes.length &&
                endTimes.length == travelDays.length,
            "All parameters must have equal array length"
        );

        for (uint i = 0; i < travelDays.length; i++) {
            _totalSlots.increment();
            TimeSlotStruct memory slot;

            slot.id = _totalSlots.current();
            slot.routeId = routeId;
            slot.ticketCost = ticketCosts[i];
            slot.startTime = startTimes[i];
            slot.endTime = endTimes[i];
            slot.day = travelDays[i];
            slot.capacity = capacities[i];

            routeTimeSlot[slot.id] = slot;
        }
    }

    function deleteTimeSlot(uint256 routeId, uint256 slotId) public onlyOwner {
        require(
            routeExists[routeId] && routeTimeSlot[slotId].routeId == routeId,
            "Route not found"
        );
        require(!routeTimeSlot[slotId].deleted, "Timeslot already deleted");

        for (uint i = 0; i < ticketHolder[routeId][slotId].length; i++) {
            payTo(
                ticketHolder[routeId][slotId][i],
                routeTimeSlot[slotId].ticketCost
            );
        }

        routeTimeSlot[slotId].deleted = true;

        routeTimeSlot[slotId].balance -=
            routeTimeSlot[slotId].ticketCost *
            ticketHolder[routeId][slotId].length;

        delete ticketHolder[routeId][slotId];
    }

    function markTimeSlot(uint256 routeId, uint256 slotId) public onlyOwner {
        require(
            routeExists[routeId] && routeTimeSlot[slotId].routeId == routeId,
            "Route not found"
        );
        require(!routeTimeSlot[slotId].deleted, "Timeslot already deleted");

        routeTimeSlot[slotId].completed = true;
        balance += routeTimeSlot[slotId].balance;
        routeTimeSlot[slotId].balance = 0;
    }

    function getTimeSlotsByDay(
        uint256 day
    ) public view returns (TimeSlotStruct[] memory RouteSlots) {
        uint256 available;
        for (uint i = 0; i < _totalSlots.current(); i++) {
            if (
                routeTimeSlot[i + 1].day == day && !routeTimeSlot[i + 1].deleted
            ) {
                available++;
            }
        }

        RouteSlots = new TimeSlotStruct[](available);

        uint256 index;
        for (uint i = 0; i < _totalSlots.current(); i++) {
            if (
                routeTimeSlot[i + 1].day == day && !routeTimeSlot[i + 1].deleted
            ) {
                RouteSlots[index].startTime = routeTimeSlot[i + 1].startTime;
                RouteSlots[index++].endTime = routeTimeSlot[i + 1].endTime;
            }
        }
    }

    function getTimeSlot(
        uint256 slotId
    ) public view returns (TimeSlotStruct memory) {
        return routeTimeSlot[slotId];
    }

    function getTimeSlots(
        uint256 routeId
    ) public view returns (TimeSlotStruct[] memory RouteSlots) {
        uint256 available;
        for (uint i = 0; i < _totalSlots.current(); i++) {
            if (
                routeTimeSlot[i + 1].routeId == routeId &&
                !routeTimeSlot[i + 1].deleted
            ) {
                available++;
            }
        }

        RouteSlots = new TimeSlotStruct[](available);

        uint256 index;
        for (uint i = 0; i < _totalSlots.current(); i++) {
            if (
                routeTimeSlot[i + 1].routeId == routeId &&
                !routeTimeSlot[i + 1].deleted
            ) {
                RouteSlots[index++] = routeTimeSlot[i + 1];
            }
        }
    }

    function buyTicket(
        uint256 routeId,
        uint256 slotId,
        uint256 tickets
    ) public payable {
        require(
            routeExists[routeId] && routeTimeSlot[slotId].routeId == routeId,
            "Route not found"
        );
        require(
            msg.value >= routeTimeSlot[slotId].ticketCost * tickets,
            "Insufficient amount"
        );
        require(
            routeTimeSlot[slotId].capacity > routeTimeSlot[slotId].seats,
            "Out of capacity"
        );

        for (uint i = 0; i < tickets; i++) {
            _totalTickets.increment();
            TicketStruct memory ticket;

            ticket.id = _totalTickets.current();
            ticket.cost = routeTimeSlot[slotId].ticketCost;
            ticket.day = routeTimeSlot[slotId].day;
            ticket.slotId = slotId;
            ticket.owner = msg.sender;
            ticket.timestamp = currentTime();

            ticketHolder[routeId][slotId].push(msg.sender);
        }

        routeTimeSlot[slotId].seats += tickets;
        routeTimeSlot[slotId].balance +=
            routeTimeSlot[slotId].ticketCost *
            tickets;
    }

    function getRouteTicketHolders(
        uint256 routeId,
        uint256 slotId
    ) public view returns (address[] memory) {
        return ticketHolder[routeId][slotId];
    }

    function withdrawTo(address to, uint256 amount) public onlyOwner {
        require(balance >= amount, "Insufficient fund");
        balance -= amount;
        payTo(to, amount);
    }

    function payTo(address to, uint256 amount) internal {
        (bool success, ) = payable(to).call{value: amount}("");
        require(success);
    }

    function currentTime() internal view returns (uint256) {
        uint256 newNum = (block.timestamp * 1000) + 1000;
        return newNum;
    }
}
