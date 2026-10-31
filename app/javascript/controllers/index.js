import { application } from "controllers/application"
import TabsController from "./tabs_controller"
application.register("tabs", TabsController)
import AnnuaireController from "./annuaire_controller"
application.register("annuaire", AnnuaireController)
import BreathingController from "./breathing_controller"
application.register("breathing", BreathingController)
