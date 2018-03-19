uri_D1 = "http://supersede.es.atos.net:8280/replan_optimizer/replan"
uri_D2 = "http://supersede.es.atos.net:8280/replan_optimizer_v2/replan"
uri_P1 = "http://platform.supersede.eu:8280/replan_optimizer/replan"
uri_P2 = "http://platform.supersede.eu:8280/replan_optimizer_v2/replan"

local = "http://localhost:8080/replan_optimizer_v2-0.0.1/replan"

Rails.application.config.x.optimizer_endpoints = [local]

localn = "http://localhost:8080/replan_optimizer_v2-0.0.1/replan-n"

Rails.application.config.x.optimizer_n_endpoints = [localn]