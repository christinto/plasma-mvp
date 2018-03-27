pragma solidity ^0.4.19;

import "./ByteUtils.sol";
import "./ECRecovery.sol";

/**
 * @title Validate
 * @dev Checks that the signatures on a transaction are valid
 */

library Validate {

    /**
     * @dev Checks if the signatures on a transaction are valid
     * @param txHash Hash of the transaction to check
     * @param blknum1 Block number of the first input
     * @param blknum2 Block number of the second input
     * @param sigs Signatures to verify
     * @return true if the transaction is valid, false otherwise
     */
    function checkSigs(bytes32 txHash, uint256 blknum1, uint256 blknum2, bytes sigs)
        internal
        view
        returns (bool)
    {
        require(sigs.length % 65 == 0 && sigs.length <= 260);

        bytes memory sig1 = ByteUtils.slice(sigs, 0, 65);
        bytes memory sig2 = ByteUtils.slice(sigs, 65, 65);

        bool sig1valid = true;
        bool sig2valid = true;
        if (blknum1 > 0) {
            sig1valid = ECRecovery.recover(txHash, sig1) == msg.sender;
        } 
        if (blknum2 > 0) {
            sig2valid = ECRecovery.recover(txHash, sig2) == msg.sender;
        }

        return sig1valid && sig2valid;
    }
}