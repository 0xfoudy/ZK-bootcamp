pragma solidity 0.8.20;
import "forge-std/console.sol";

contract Week3 {

    struct ECPoint {
        uint256 x;
        uint256 y;
    }

    function expmod(uint base, uint e, uint m) public view returns (uint o) {
        assembly {
        // define pointer
        let p := mload(0x40)
        // store data assembly-favouring ways
        mstore(p, 0x20)             // Length of Base
        mstore(add(p, 0x20), 0x20)  // Length of Exponent
        mstore(add(p, 0x40), 0x20)  // Length of Modulus
        mstore(add(p, 0x60), base)  // Base
        mstore(add(p, 0x80), e)     // Exponent
        mstore(add(p, 0xa0), m)     // Modulus
        if iszero(staticcall(sub(gas(), 2000), 0x05, p, 0xc0, p, 0x20)) {
            revert(0, 0)
        }
        // data
        o := mload(p)
        }
    }
    
    uint256 public constant order = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
    uint256 public G_x = 55066263022277343669578718895168534326250603453777594175500187360389116729240;
    uint256 public G_y = 32670510020758816978083085130507043184471273380659243275938904335757337482424;

    function getInverse(uint256 toInverse) public returns (uint256 inverse) {
        inverse = expmod(toInverse, order - 2, order); 
    }

    // I know two rationals a,b that add up to num/den, i give you A, B, num and den
    function rationalAdd(ECPoint memory A, ECPoint memory B, uint256 num, uint256 den) public returns (bool verified) {
        
/* COMMENTED PART IS WRONG
        // Gnum
        uint256 ECNum_x = mulmod(G_x, num, order);
        uint256 ECNum_y = mulmod(G_y, num, order);

        // GDen
        uint256 ECDen_x = mulmod(G_x, den, order);
        uint256 ECDen_y = mulmod(G_y, den, order);

        uint256 ECFraction_x = mulmod(ECNum_x, getInverse(ECDen_x), order);
        uint256 ECFraction_y = mulmod(ECNum_y, getInverse(ECDen_y), order);
*/

        uint256 fraction = mulmod(num, getInverse(den), order);
        uint256 ECFraction_x = mulmod(G_x, fraction, order);
        uint256 ECFraction_y = mulmod(G_y, fraction, order);

        return (addmod(A.x, B.x, order)) == ECFraction_x && (addmod(A.y, B.y, order)) == ECFraction_y;
    }

    function matmul(uint256[] calldata matrix,
                uint256 n, // n x n for the matrix
                ECPoint[] calldata s, // n elements
                uint256[] calldata o // n elements
               ) public returns (bool) {

        // revert if dimensions don't make sense or the matrices are empty
        require(matrix.length > 0 && matrix.length == n*n && s.length == n && o.length == n);

        ECPoint[] memory result = new ECPoint[](n);

        // return true if Ms == o elementwise. You need to do n equality checks. 
        //If you're lazy, you can hardcode n to 3, but it is suggested that you do this with a for loop 
        for(uint256 i = 0; i < n*n; i=i+n) {

            uint256 result_x = 0;
            uint256 result_y = 0;

            for(uint256 j = 0; j < n; ++j) {
                result_x = addmod(result_x, mulmod(matrix[i+j], s[j].x, order), order);
                result_y = addmod(result_y, mulmod(matrix[i+j], s[j].y, order), order);
            }
                    
            result[i/n] = ECPoint(result_x, result_y);
        }

        for(uint256 i = 0; i < n; ++i){
            if(result[i].x != mulmod(G_x, o[i], order) && result[i].y != mulmod(G_y, o[i], order)) return false;
        }
        return true;
    }
}