import CardController from "../controllers/card-controller";

import { Router } from "express";

class CardRouter {
    // POST ; Creates a new flashcard (does not assign to a flashcard set).
    createCard = Router().post("/card/create", CardController.createCard); // Passed

    // DELETE ; Deletes a flashcard.
    deleteCard = Router().delete("/card/delete/:cardID", CardController.deleteCard); 

    // PUT ; Updates the presented text of a flashcard.
    updatePresentedText = Router().put("/card/update-presented-text/:cardID", CardController.updatePresentedText);

    // PUT ; Updates the hidden text of a flashcard.
    updateHiddenText = Router().put("/card/update-hidden-text/:cardID", CardController.updateHiddenText);

    // PUT ; Updates both the presented and hidden text of a flashcard.
    updateCardText = Router().put("/card/update-text/:cardID", CardController.updateCardText);

    // GET ; Gets the flashcard with the given cardID.
    getCard = Router().get("card/:cardID", CardController.getCard);
}

export default new CardRouter();
