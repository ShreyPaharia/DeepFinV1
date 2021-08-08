import { Received as ReceivedEvent } from "../generated/LendingPoolDF/LendingPoolDF"
import { Received } from "../generated/schema"

export function handleReceived(event: ReceivedEvent): void {
  let entity = new Received(
    event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  )
  entity.operator = event.params.operator
  entity.from = event.params.from
  entity.to = event.params.to
  entity.amount = event.params.amount
  entity.userData = event.params.userData
  entity.operatorData = event.params.operatorData
  entity.save()
}
