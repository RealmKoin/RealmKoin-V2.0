pragma solidity ^0.4.11;
// @library: solidity
// RealmKoin Donations Contract.
// Author: Skrypt
// GitHub: Www.Github.com/RealmKoin
// GitLab: git.techenterprises.me
// ProjectWeb: Www.RealmKoin.com
// SourceWeb: Www.TechEnterprises.me
// License Standard T.G.L(D: 2017) (The Guild License (Version Date: 2017*))
// (* Any And All Revised Future Editorials Of T.G.L Apply From 1/1/2017 To Date.)
// RealmKoin Ethereum Donations Smart Contract.
// Smart Contract That Has 0 Authorization To The RealmKoin Network. 
// Sends Ethereum From Donations Account To Specified Address
// Appendable Ion For Network Connections.
// Ion Donate // Ion Functions.
// RealmKoin Network Contracts Are Public And RealmKoin Team Deployed ONLY.
// This Contract Requires Authenticated Callers.
// Fallback () Function Refers To Donations.

// Usage Extended To Public At A Later Date.

contract RealmKoin_Donations {
    address public Donations_Contract;
    bool public Donations_Contract_Set;
    bool private do_nothing;
    uint256 public Donations;
    uint256 public Total_Donations;

    struct network_data {
        bool Ion;
        bool Stat;
    }
    
    mapping(address => network_data) public Network;

    event Donation_Sent(address _AdminSig, address _To, uint _MsgValue);
    event Donated(address _AdminSig, address _To, uint _MsgValue);
    event Donation_Received(address _From, uint _MsgValue);
    event Set_Donations_Address(address _Admin, address _DonationAddress);
    event Donations_Added(address _From, uint256 _MsgValue);
    event Donation_Forwarded(address _From, address _To, uint256 _Value);
    event MsgValue_Needed(address _Caller);
    event MsgValue_Accepted(address _MsgValueSender);
    event Donations_Unavailable(address _Admin, uint256 _Donations);
    event Not_On_Network(address _CallerSig);
    event Ion_Linked(address _NewIonSig);
    event Ion_UnLinked(address _RemovedIonSig);

    modifier Is_Sender_Ion() {
        if (Network[msg.sender].Ion != true) {
            do_nothing = true;
            Not_On_Network(msg.sender);
        }
        _;
    }
    modifier Is_Sender_Stat() {
        if (Network[msg.sender].Stat != true) {
            do_nothing = true;
            Not_On_Network(msg.sender);
        }
        _;
    }

    modifier Value_Needed() {
        if (msg.value == 0) {
            do_nothing = true;
            MsgValue_Needed(msg.sender);
        }
        _;
    }


    modifier Are_Donations_Available(uint256 _value) {
        if (Donations < _value) {
            do_nothing = true;
            Donations_Unavailable(msg.sender, Donations);
        }
        _;
    }

    modifier MsgValue() {
        if (msg.value > 0) {
            do_nothing = false;
            Donations += msg.value;
            Total_Donations += msg.value;
            MsgValue_Accepted(msg.sender);
        }
        _;
    }


    function RealmKoin_Donations(address _Stat) {
        Donations = 0;
        Total_Donations = 0;
        Donations_Contract_Set = false;
        Network[msg.sender].Ion = true;
        Network[_Stat].Ion = true;
        Network[_Stat].Stat = true;
        do_nothing = false;
    }
    function Link_Ion(address _NewIon) public payable
     MsgValue()
     Is_Sender_Stat()
     returns (bool sucess)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
         Network[_NewIon].Ion = true;
         Ion_Linked(_NewIon);
         return true;
     }
    }
    function UnLink_Ion(address _IonSig) public payable
     MsgValue()
     Is_Sender_Stat()
     returns (bool success)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
        Network[_IonSig].Ion = false;
        Ion_UnLinked(_IonSig);
        return true;
     }
    }

    function Manual_Donate(address _to, uint256 _value) public payable // If No Donations Contract (Auto-Send) Has Been Set
     MsgValue()
     Is_Sender_Ion()
     Are_Donations_Available(_value)
     returns (bool sucess)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
        if (!_to.call.value(_value)()) {
            return false;
        }
        else
        {
            Donation_Sent(msg.sender, _to, _value);
            Donations -= _value;
            return true;
        }
     }
    }


    function Set_Donations_Contract(address _d_set) public payable
     MsgValue()
     Is_Sender_Stat() 
     returns (bool sucess)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
        Donations_Contract = _d_set;
        Donations_Contract_Set = true;
        Set_Donations_Address(msg.sender, _d_set);
        return true;
     }
    }
    
    function Disengage(address _Beneficiary) public 
     Is_Sender_Stat()
     returns (bool success)
     {
      if (do_nothing == true) 
      {
          do_nothing = false;
          return false;
      }
      else
      {
          selfdestruct(_Beneficiary);
      }
     }
    function() payable 
    {
      if (Donations_Contract_Set == true) {
       if (!Donations_Contract.call.value(msg.value)()) {
            Total_Donations += msg.value;
            Donation_Forwarded(msg.sender, Donations_Contract, msg.value);
       }
       else
       {
            Donations += msg.value;
            Total_Donations += msg.value;
            Donation_Received(msg.sender, msg.value);
       }
      }
      else
      {
       Total_Donations += msg.value;
       Donations += msg.value;
       Donation_Received(msg.sender, msg.value);
      } 
    }
}
