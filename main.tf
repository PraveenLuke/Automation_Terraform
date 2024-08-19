variable "clusters" {
  type = map(object({
    task_definition = string
    cluster_arn     = string
    desired_count   = number
  }))
  default = {
    # QA Backend Cluster Services
    "QADotnetCronECSService" = {
      task_definition = "arn:aws:ecs:eu-west-2:896520071999:task-definition/QA_Dotnet_Cron_ECS_Task:2"
      cluster_arn     = "arn:aws:ecs:eu-west-2:896520071999:cluster/QaBackendCluster"
      desired_count   = 1
    },
    "QADotnetECSService"     = {
      task_definition = "arn:aws:ecs:eu-west-2:896520071999:task-definition/QA_Dotnet_ECS_Task:1"
      cluster_arn     = "arn:aws:ecs:eu-west-2:896520071999:cluster/QaBackendCluster"
      desired_count   = 1
    },
    "QANodeCronECSService"   = {
      task_definition = "arn:aws:ecs:eu-west-2:896520071999:task-definition/QA_Node_Cron_ECS_Task:2"
      cluster_arn     = "arn:aws:ecs:eu-west-2:896520071999:cluster/QaBackendCluster"
      desired_count   = 1
    },
    "QANodeECSService"       = {
      task_definition = "arn:aws:ecs:eu-west-2:896520071999:task-definition/QA_Node_ECS_Task:2"
      cluster_arn     = "arn:aws:ecs:eu-west-2:896520071999:cluster/QaBackendCluster"
      desired_count   = 1
    },

    # Dev Backend Cluster Services
    "DevDotnetCronECSService" = {
      task_definition = "arn:aws:ecs:eu-west-2:896520071999:task-definition/Dev_Dotnet_Cron_ECS_Task:1"
      cluster_arn     = "arn:aws:ecs:eu-west-2:896520071999:cluster/DevBackendCluster"
      desired_count   = 1
    },
    "DevDotnetECSService"     = {
      task_definition = "arn:aws:ecs:eu-west-2:896520071999:task-definition/Dev_Dotnet_ECS_Task:1"
      cluster_arn     = "arn:aws:ecs:eu-west-2:896520071999:cluster/DevBackendCluster"
      desired_count   = 1
    },
    "DevNodeCronECSService"   = {
      task_definition = "arn:aws:ecs:eu-west-2:896520071999:task-definition/Dev_Node_Cron_ECS_Task:1"
      cluster_arn     = "arn:aws:ecs:eu-west-2:896520071999:cluster/DevBackendCluster"
      desired_count   = 1
    },
    "DevNodeECSService"       = {
      task_definition = "arn:aws:ecs:eu-west-2:896520071999:task-definition/Dev_Node_ECS_Task:3"
      cluster_arn     = "arn:aws:ecs:eu-west-2:896520071999:cluster/DevBackendCluster"
      desired_count   = 1
    }
  }
}

resource "aws_ecs_service" "services" {
  for_each = var.clusters

  name            = each.key
  cluster         = each.value.cluster_arn
  task_definition = each.value.task_definition
  desired_count   = each.value.desired_count

  lifecycle {
    ignore_changes = [
      health_check_grace_period_seconds,
      network_configuration,
      load_balancer,
      deployment_controller,
      deployment_circuit_breaker,
      capacity_provider_strategy,
      alarms,
      tags,
      propagate_tags
    ]
  }
}