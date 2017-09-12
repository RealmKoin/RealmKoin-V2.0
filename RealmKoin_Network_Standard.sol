pragma solidity ^0.4.11;
// @library: solidity
// RealmKoin Network Contract.
// Author: Skrypt
// GitHub: Www.Github.com/RealmKoin
// GitLab: git.techenterprises.me
// ProjectWeb: Www.RealmKoin.com
// SourceWeb: Www.TechEnterprises.me
// License Standard T.G.L(D: 2017) (The Guild License (Version Date: 2017*))
// (* Any And All Revised Future Editorials Of T.G.L Apply From 1/1/2017 To Date.)
// RealmKoin Network Smart Contract Standard.
// Smart Contract Is Standard Attachment For RealmKoin Network Authentication.*
// Authenticates Caller For Specified Functions / Modifiers
// Contracts Connected To The RealmKoin Network Are Public And RealmKoin Team Deployed ONLY.
// This Contract Standard Allows RealmKoin Network Contract Functions To Only Be Utilized Within The Specified Range Of Network Users
// Fallback () Is Not Included (Standard To Come.)
// *@Reader: My New Standard Seems To Be Combine Over Import / Multi-Compile When Possible.



contract RealmKoin_Network {
    
    address public Stat_Signature;
    
    struct network_data {
        bool Ion;
        bool Stat;
    }
    mapping(address => network_data) public Network;
    modifier Is_Sender_Ion() {
        if (Network[msg.sender].Ion != true) {
            ( ...Optional Code... );
        }
        _;
    }
    modifier Is_Sender_Stat() {
        if (Network[msg.sender].Stat != true) {
            ( ...Optional Code... );
        }
        _;
    }
    function RealmKoin_Network(address _StatAddress)
     public
    {
        Stat_Signature = _StatAddress;
        Network[msg.sender].Ion = true;
        Network[_StatAddress].Ion = true;
        Network[_StatAddress].Stat = true;
    }
    function Link_Ion(address _IonAddress) 
     public
     Is_Sender_Ion() {
     if (! ... Call To Stat ...) {
        (... Exit Code ...) // Standard Is Universal Given The Multiple Ways Of Exit Via Solidity.
     }
     else
     {
        Network[_IonAddress].Ion = true;
        (... Optional Code ...)
     }
    }
    function UnLink_Ion(address _IonAddress)
     public
     Is_Sender_Stat()
     {
        Network[_IonAddress].Ion = false;
        (... Optional Code ...)
     }
}
