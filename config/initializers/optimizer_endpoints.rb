uri_D1 = "http://supersede.es.atos.net:8280/replan_optimizer/replan"
uri_D2 = "http://supersede.es.atos.net:8280/replan_optimizer_v2/replan"
uri_P1 = "http://localhost:8280/replan_optimizer/replan"
uri_P2 = "http://localhost:8280/replan_optimizer_v2/replan"

Rails.application.config.x.optimizer_endpoints = [uri_P1, uri_P2, uri_D1, uri_D2]