pragma solidity ^0.4.11;
// @library: solidity
// RealmKoin Refund Contract.
// Author: Skrypt
// GitHub: Www.Github.com/RealmKoin
// GitLab: git.techenterprises.me
// ProjectWeb: Www.RealmKoin.com
// SourceWeb: Www.TechEnterprises.me
// License Standard T.G.L(D: 2017) (The Guild License (Version Date: 2017*))
// (* Any And All Revised Future Editorials Of T.G.L Apply From 1/1/2017 To Date.)
// RealmKoin Ethereum Refund Smart Contract.
// Smart Contract That Has 0 Authorization To The RealmKoin Network. 
// Sends Ethereum From Funds / Donations Account To Specified Address
// Appendable Ion For Network Connections.
// Ion Refund // Collect Donations Functions.
// RealmKoin Network Contracts Are Public And RealmKoin Team Deployed ONLY.
// This Contract Requires Authenticated Callers But Has No Authority Within The Network.
// Fallback () Function Refers To Donations.

// Usage Extended To Public At A Later Date.

// Contract Definition Below:
contract RealmKoin_Refund {
    address public Donations_Contract;
    bool public Donations_Contract_Set;
    bool private do_nothing;
    uint256 public Donations;
    uint256 public Total_Donations;
    uint256 public Funds;

// Structures Below:
    struct network_data {
        bool Ion;
        bool Stat;
    }

// Mappings Below: 
    mapping(address => network_data) public Network;

// Events Below:
    event Donations_Withdrawn(address _IonSig, address _To, uint _MsgValue);
    event Refunded(address _To, uint _MsgValue);
    event Donation_Received(address _SenderSig, uint _MsgValue);
    event Set_Donations_Address(address _IonSig, address _DonationAddress);
    event Funds_Added(address _SenderSig, uint256 _MsgValue);
    event MsgValue_Needed(address _CallerSig);
    event MsgValue_Accepted(address _MsgValueSender);
    event Funds_Unavailable(address _IonSig, uint256 _Funds);
    event Donations_Unavailable(address _IonSig, uint256 _Donations);
    event Not_On_Network(address _CallerSig);
    event Stat_Only_Option(address _CallerSig);
    event Ion_Linked(address _IonLinked);
    event Ion_UnLinked(address _IonUnlinked);

// Modifiers Below:
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
            Stat_Only_Option(msg.sender);
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
    modifier Are_Funds_Available(uint256 _value) {
        if (Funds < _value) {
            do_nothing = true;
            Funds_Unavailable(msg.sender, Funds);
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
    function RealmKoin_Refund(address _Stat) {
        Donations = 0;
        Total_Donations = 0;
        Funds = 0;
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
    function Unlink_Ion(address _IonName) public payable
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
        Network[_IonName].Ion = false;
        Ion_UnLinked(_IonName);
        return true;
     }
    }
    
    function Fill_Funds() public payable
     Is_Sender_Ion()
     Value_Needed()
     returns (bool success)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
        Funds += msg.value;
        Funds_Added(msg.sender, msg.value);
        return true;
     }
    }


    function Refund(address _to, uint256 _value) public payable
     MsgValue()
     Is_Sender_Ion()
     Are_Funds_Available(_value)
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
            Refunded(_to, _value);
            Funds -= _value;
            return true;
        }
     }
    }

    function Collect_Donations(address _to, uint256 _value) public payable
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
            Donations_Withdrawn(msg.sender, _to, _value);
            Donations -= _value;
            return true;
        }
     }
    }

    function Set_Donations_Contract(address _DonationDestination) public payable
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
        Donations_Contract = _DonationDestination;
        Donations_Contract_Set = true;
        Set_Donations_Address(msg.sender, _DonationDestination);
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
