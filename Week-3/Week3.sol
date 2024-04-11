pragma solidity 0.8.20;

contract Week3 {
    constant uint256 order = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    struct ECPoint {
        uint256 x;
        uint256 y;
    }

    function rationalAdd(ECPoint calldata A, ECPoint calldata B, uint256 num, uint256 den) public view returns (bool verified) {
        // modExp(a, -1, curve_order) == modExp(a, curve_order - 2, curve_order)
        return mulmod(A.x, modExp(A.y, order-2, order)) + mulmod(B.x, modExp(B.y, order-2, order));
        // return true if the prover knows two numbers that add up to num/den
    }

}