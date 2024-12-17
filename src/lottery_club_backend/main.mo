import _Array "mo:base/Array";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";

actor LotteryClub {
    stable var participants : [Principal] = [];
    stable var contributions : [Nat] = [];
    stable var currentIndex : Nat = 0;
    stable var totalContributions : Nat = 0;
    let maxParticipants : Nat = 10;
    let contributionAmount : Nat = 1; // 1 ICP

    // Use buffers for mutable operations
    var participantsBuffer = Buffer.Buffer<Principal>(0);
    var contributionsBuffer = Buffer.Buffer<Nat>(0);

    // Add this method to match your frontend
    public func greet(name : Text) : async Text {
        return "Welcome to Lottery Club, " # name # "!";
    };

    public func joinClub(caller: Principal) : async Bool {
        if (participantsBuffer.size() < maxParticipants) {
            participantsBuffer.add(caller);
            contributionsBuffer.add(0);
            // Update stable storage
            participants := Buffer.toArray(participantsBuffer);
            contributions := Buffer.toArray(contributionsBuffer);
            return true;
        };
        return false;
    };

    public func contribute(caller: Principal, amount: Nat) : async Bool {
        // Find the index of the participant
        label findIndex for (i in participantsBuffer.vals()) {
            if (Principal.equal(i, caller)) {
                if (amount >= contributionAmount) {
                    // Update the contribution in the buffer
                    contributionsBuffer.put(
                        participantsBuffer.size() - 1, 
                        contributionsBuffer.get(participantsBuffer.size() - 1) + amount
                    );
                    
                    // Update stable storage
                    contributions := Buffer.toArray(contributionsBuffer);
                    totalContributions += amount;
                    return true;
                };
                break findIndex;
            }
        };
        return false;
    };

    public func distributeFunds() : async () {
        if (participantsBuffer.size() > 0 and currentIndex < participantsBuffer.size()) {
            let _recipient = participantsBuffer.get(currentIndex);
            // TODO: Implement actual fund transfer logic
            currentIndex += 1;
        };
    };

    public query func getParticipants() : async [Principal] {
        return participants;
    };

    public query func getTotalContributions() : async Nat {
        return totalContributions;
    };
}