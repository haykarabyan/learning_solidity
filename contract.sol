// Sample smartcontract for test result exchange between students
// if student a requests a change, first he needs to provide the results, if he provides the result
// second student share the result as well
// STILL WORK IN PROGRESS

pragma solidity 0.8.11;

contract Project {
    enum Status {COMPLETED, CENCELED}

    struct Request {
        string title;
        bool has_sent;
    }

    Request[] public requests;

    address public requester;
    address public responder;
    Status public status;

    event RequestCreated(string title);
    event RequestPaid(address receiver, uint256 amount);
    event SwappingCompleted(
        address requster,
        address responder,
        uint256 amount,
        Status status
    );
    event SwapCanceled(uint256 remainingPayments, Status status);

    constructor(
        address payable _employer,
        address payable _freelancer,
        uint256 _deadline,
        uint256 _price
    ) public {
        requester = _employer;
        responder = _freelancer;
        status = Status.PENDING;
    }

    modifier onlyRequester() {
        require(msg.sender == requester, "Only Requester!");
        _;
    }

    modifier onlyResponder() {
        require(msg.sender == responder, "Only Responder!");
        _;
    }

    modifier onlyPendingProject() {
        require(status == Status.PENDING, "Only pending!");
        _;
    }


    function createRequest(string memory _title)
        public
        onlyResponder
        onlyPendingProject
    {

        Request memory request = Request({
            title: _title
        });

        requests.push(request);

        emit RequestCreated(_title, request.locked, request.paid);
    }


    function payRequest(uint256 _index) public onlyResponder {
        Request storage request = requests[_index];
        emit RequestPaid(msg.sender, request.amount);
    }


    receive() external payable {}
}
