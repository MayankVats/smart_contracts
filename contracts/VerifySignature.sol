// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
0. message to sign
1. hash(message)
2. sign(hash(message), private key) | offline
3. ecrecover(hash(message), signature) == signer
*/

contract VerifySignature {
    /**
    @notice function to verify the signature
    @param _signer address of the signer
    @param _message data that was signed
    @param _sig the signature
    @return true or false
  */
    function verify(
        address _signer,
        string memory _message,
        bytes memory _sig
    ) external pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 signedMessageHash = getSignedMessageHash(messageHash);

        return recover(signedMessageHash, _sig) == _signer;
    }

    /**
      @notice function to get the hash of the message to sign
      @param _message data to hash
      @return bytes32 hash of the message to sign
    */
    function getMessageHash(string memory _message)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_message));
    }

    /**
      @notice function to sign the message hash
      @notice this is the actual message that you sign when you sign the message off chain
      @param _messageHash hash of the message to be signed
    */
    function getSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    /**
      @notice function to recover the address of the signer
      @param _signedMessageHash hash of the message to sign (with prefixed data)
      @param _sig the actual signature
    */
    function recover(bytes32 _signedMessageHash, bytes memory _sig)
        public
        pure
        returns (address)
    {
        // r and s here are cryptographic parameters used for digital signature
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);

        return ecrecover(_signedMessageHash, v, r, s);
    }

    /**
      @notice function to split the signature
      @param _sig the actual signature
      @return r
      @return s
      @return v
    */
    function _split(bytes memory _sig)
        internal
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        // make sure length of the signature is 65 (32 + 32 + 1(8 bits))
        require(_sig.length == 65, "Invalid Signature Length");

        // * _sig is the dynamic data
        //   for dynamic data first 32 bytes stores the length of the data

        // * variable _sig is the pointer to where the actual signature is stored in memory
        assembly {
            // from the pointer of _sig skip the first 32 bytes
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))

            // get the first byte from the 32 bytes after 96
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}

// https://docs.metamask.io/guide/signing-data.html#signing-data-with-metamask
