pragma solidity 0.8.20;
import "forge-std/console.sol";
import {Test, console2} from "forge-std/Test.sol";
import {Week3} from "../Week-3/week3.sol";


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

    function testAddFractions(uint256 a, uint256 b, uint256 num, uint256 den) public returns (bool){
        // Ga
        Week3.ECPoint memory A = Week3.ECPoint(mulmod(G_x, a, order), mulmod(G_y, a, order));
        // Gb
        Week3.ECPoint memory B = Week3.ECPoint(mulmod(G_x, b, order), mulmod(G_y, b, order));


        return testCa.rationalAdd(A, B, num, den);
    }

    function testH() public {
        assertTrue(testAddFractions(1, 1, 4, 2));
        assertTrue(testAddFractions(0, 2, 4, 2));
        assertTrue(testAddFractions(2, 0, 4, 2));
        assertTrue(testAddFractions(3, 0, 6, 2));
        assertTrue(testAddFractions(0, 3, 6, 2));
        assertTrue(testAddFractions(1, 2, 6, 2));
        assertTrue(testAddFractions(2, 1, 6, 2));


        assertTrue(testAddFractions(12, 13, 100, 4));
        assertTrue(testAddFractions(24, 1, 100, 4));
        assertTrue(testAddFractions(1, 24, 100, 4));
        assertTrue(testAddFractions(25, 0, 100, 4));
    }

    function testMatMul() public {
 /*       (uint256[] calldata matrix,
                uint256 n, // n x n for the matrix
                ECPoint[] calldata s, // n elements
                uint256[] calldata o // n elements
        ) */
        uint256 n = 3;
        uint256[] memory matrix = new uint256[](n*n);
        matrix[0] = 1;
        matrix[1] = 1;
        matrix[2] = 1;
        matrix[3] = 1;
        matrix[4] = 1;
        matrix[5] = 1;
        matrix[6] = 1;
        matrix[7] = 1;
        matrix[8] = 1;

        Week3.ECPoint[] memory s = new Week3.ECPoint[](n);
        
        s[0] = Week3.ECPoint(mulmod(G_x, 1, order), mulmod(G_y, 1, order));
        s[1] = Week3.ECPoint(mulmod(G_x, 1, order), mulmod(G_y, 1, order));
        s[2] = Week3.ECPoint(mulmod(G_x, 1, order), mulmod(G_y, 1, order));

        uint256[] memory o = new uint256[](3);
        o[0] = 3;
        o[1] = 3;
        o[2] = 3;

        assertTrue(testCa.matmul(matrix, n, s, o));
    }

}