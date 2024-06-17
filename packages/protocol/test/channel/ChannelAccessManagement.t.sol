// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IUpgradePath } from "../../src/interfaces/IUpgradePath.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";
import { ChannelHarness } from "../utils/ChannelHarness.t.sol";
import { Test, console } from "forge-std/Test.sol";
import { ERC1155 } from "openzeppelin-contracts/token/ERC1155/ERC1155.sol";

contract ChannelAccess is Test {
  ChannelHarness channelImpl;
  address admin = makeAddr("admin");

  function setUp() public {
    channelImpl = new ChannelHarness(address(0), address(0));
  }

  function test_managers_callerNotAdminAfterInitialization() external {
    address sampleManager = makeAddr("sample manager");
    address[] memory channelManagers = new address[](1);
    channelManagers[0] = sampleManager;

    // initialize the channel
    channelImpl.initialize(
      "https://example.com/api/token/0",
      "my contract",
      admin,
      channelManagers,
      new bytes[](0),
      new bytes(0)
    );

    // check managers after initialization
    assertTrue(channelImpl.isManager(admin));
    assertTrue(channelImpl.isManager(sampleManager));

    // ensure non-manager is not a manager
    assertFalse(channelImpl.isManager(makeAddr("non-manager")));
    // ensure the initializer is no longer a manager
    assertFalse(channelImpl.isManager(address(this)));
  }

  function test_managers_adminCanAddNewManager() external {
    address sampleManager = makeAddr("sample manager");

    address[] memory channelManagers = new address[](1);
    channelManagers[0] = sampleManager;

    channelImpl.initialize(
      "https://example.com/api/token/0",
      "my contract",
      admin,
      channelManagers,
      new bytes[](0),
      new bytes(0)
    );

    address[] memory newManagers = new address[](1);
    newManagers[0] = makeAddr("new manager");

    // verify that admin can add another manager
    vm.startPrank(admin);
    channelImpl.setManagers(newManagers);
    vm.stopPrank();
  }

  function test_managers_adminSetManagers() external {
    address sampleManager = makeAddr("sample manager");
    address sampleManager2 = makeAddr("sample manager 2");

    address[] memory channelManagers = new address[](2);
    channelManagers[0] = sampleManager;
    channelManagers[1] = sampleManager2;

    channelImpl.initialize(
      "https://example.com/api/token/0",
      "my contract",
      admin,
      channelManagers,
      new bytes[](0),
      new bytes(0)
    );

    address[] memory newManagers = new address[](1);
    newManagers[0] = makeAddr("new manager");

    // verify manager length is 2
    assertEq(channelImpl.getRoleMemberCount(keccak256("MANAGER_ROLE")), 2);
    vm.startPrank(admin);
    channelImpl.setManagers(newManagers);
    // verify manager length is 1
    assertEq(channelImpl.getRoleMemberCount(keccak256("MANAGER_ROLE")), 1);
    vm.stopPrank();

    // verify that the old managers are no longer managers
    assertFalse(channelImpl.isManager(sampleManager));
    assertFalse(channelImpl.isManager(sampleManager2));

    // verify that the new manager is a manager
    assertTrue(channelImpl.isManager(newManagers[0]));

    // verify that the admin is still a manager
    assertTrue(channelImpl.isManager(admin));
  }

  function test_managers_revertManagerAddNewManager() external {
    address sampleManager = makeAddr("sample manager");

    address[] memory channelManagers = new address[](1);
    channelManagers[0] = sampleManager;

    channelImpl.initialize(
      "https://example.com/api/token/0",
      "my contract",
      admin,
      channelManagers,
      new bytes[](0),
      new bytes(0)
    );

    address[] memory newManagers = new address[](1);
    newManagers[0] = makeAddr("new manager");

    // verify that a manager cannot add another manager
    vm.startPrank(sampleManager);
    vm.expectRevert();
    channelImpl.setManagers(newManagers);
    vm.stopPrank();
  }

  function test_managers_revertManagerSetManagers() external {
    address sampleManager = makeAddr("sample manager");
    address sampleManager2 = makeAddr("sample manager 2");

    address[] memory channelManagers = new address[](2);
    channelManagers[0] = sampleManager;
    channelManagers[1] = sampleManager2;

    channelImpl.initialize(
      "https://example.com/api/token/0",
      "my contract",
      admin,
      channelManagers,
      new bytes[](0),
      new bytes(0)
    );

    // verify that a manager cannot add another manager
    vm.startPrank(sampleManager);
    vm.expectRevert();
    channelImpl.setManagers(new address[](0));
    vm.stopPrank();
  }

  function test_managers_noPublicAccessToRoleManagement() external {
    channelImpl.initialize(
      "https://example.com/api/token/0",
      "my contract",
      admin,
      new address[](0),
      new bytes[](0),
      new bytes(0)
    );

    address newManager = makeAddr("new manager");
    address newAdmin = makeAddr("new admin");

    // verify that a manager cannot remove the admin
    vm.startPrank(admin);

    vm.expectRevert();
    channelImpl.grantRole(0x00, newManager);

    vm.expectRevert();
    channelImpl.revokeRole(0x00, newManager);

    vm.stopPrank();
  }

  function test_managers_transferAdmin() external {
    channelImpl.initialize(
      "https://example.com/api/token/0",
      "my contract",
      admin,
      new address[](0),
      new bytes[](0),
      new bytes(0)
    );

    address newAdmin = makeAddr("new admin");

    // verify that the admin can transfer admin role
    vm.startPrank(admin);
    channelImpl.transferAdmin(newAdmin);
    vm.stopPrank();
    assertFalse(channelImpl.isAdmin(admin));
    assertTrue(channelImpl.isAdmin(newAdmin));
  }

  function test_managers_renounceRole() external {
    address sampleManager = makeAddr("sample manager");
    address sampleManager2 = makeAddr("sample manager 2");

    address[] memory channelManagers = new address[](2);
    channelManagers[0] = sampleManager;
    channelManagers[1] = sampleManager2;

    channelImpl.initialize(
      "https://example.com/api/token/0",
      "my contract",
      admin,
      channelManagers,
      new bytes[](0),
      new bytes(0)
    );

    // verify that a manager can renounce their role
    vm.startPrank(sampleManager);
    channelImpl.renounceRole(keccak256("MANAGER_ROLE"), sampleManager);
    assertFalse(channelImpl.isManager(sampleManager));
    vm.stopPrank();

    // verify that an admin cannot renounce their role
    vm.startPrank(admin);
    vm.expectRevert();
    channelImpl.renounceRole(0x00, admin);
    vm.stopPrank();
  }
}
