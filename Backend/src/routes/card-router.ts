import CardController from "../controllers/card-controller";

import { Router } from "express";

class CardRouter {
    // POST ; Creates a new flashcard (does not assign to a flashcard set).
    createCard = Router().post("/create", CardController.createCard); 

    // DELETE ; Deletes a flashcard.
    deleteCard = Router().delete("/delete/:cardID", CardController.deleteCard); 

    // PUT ; Updates the presented text of a flashcard.
    updatePresentedText = Router().put("/update-presented-text/:cardID", CardController.updatePresentedText);

    // PUT ; Updates the hidden text of a flashcard.
    updateHiddenText = Router().put("/update-hidden-text/:cardID", CardController.updateHiddenText);

    // PUT ; Updates both the presented and hidden text of a flashcard.
    updateCardText = Router().put("/update-card-text/:cardID", CardController.updateCardText);

    // GET ; Gets the flashcard with the given cardID.
    getCard = Router().get("/:cardID", CardController.getCard);
}

export default new CardRouter();
