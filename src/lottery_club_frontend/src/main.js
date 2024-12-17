import { LotteryClub } from '../declarations/lottery_club_backend/index.js';

document.addEventListener("DOMContentLoaded", async () => {
    const joinButton = document.getElementById("joinButton");
    const nameInput = document.getElementById("nameInput");
    const messageDiv = document.getElementById("message");

    joinButton.addEventListener("click", async () => {
        const name = nameInput.value.trim();
        if (name) {
            try {
                // Call the greet function on the backend canister
                const greeting = await LotteryClub.greet(name);
                
                // Display message
                messageDiv.textContent = greeting;
                messageDiv.style.color = "green";

                // Optional: Clear input after successful greeting
                nameInput.value = "";
            } catch (error) {
                console.error("Error calling greet:", error);
                
                // Display error message
                messageDiv.textContent = "An error occurred. Please try again.";
                messageDiv.style.color = "red";
            }
        } else {
            messageDiv.textContent = "Please enter your name.";
            messageDiv.style.color = "red";
        }
    });
});