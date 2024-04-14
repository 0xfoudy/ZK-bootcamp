pragma solidity 0.8.20;
import "forge-std/console.sol";
import {Test, console2} from "forge-std/Test.sol";
import {Week3} from "../src/week3.sol";


contract TestWeek3 is Test{

    Week3 testCa;
    uint256 G_x;
    uint256 G_y;
    uint256 order;

    function setUp() public {
        testCa = new Week3();
        G_x = testCa.G_x();
        G_y = testCa.G_y();
        order = testCa.order();

    }

    function testAddFractions(uint256 a, uint256 b, uint256 num, uint256 den) public {
        // Ga
        Week3.ECPoint memory A = Week3.ECPoint(mulmod(G_x, a, order), mulmod(G_y, a, order));
        // Gb
        Week3.ECPoint memory B = Week3.ECPoint(mulmod(G_x, b, order), mulmod(G_y, b, order));


        console.log(testCa.rationalAdd(A, B, num, den));
    }

    function testH() public {
        testAddFractions(1, 1, 4, 2);
        testAddFractions(0, 2, 4, 2);
        testAddFractions(2, 0, 4, 2);
        testAddFractions(3, 0, 6, 2);
        testAddFractions(0, 3, 6, 2);
        testAddFractions(1, 2, 6, 2);
        testAddFractions(2, 1, 6, 2);


        testAddFractions(12, 13, 100, 4);
        testAddFractions(24, 1, 100, 4);
        testAddFractions(1, 24, 100, 4);
        testAddFractions(25, 0, 100, 4);
    }

}