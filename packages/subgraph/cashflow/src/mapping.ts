import {
  TransferSingle as TransferSingleEvent,
  URI as URIEvent
} from "../generated/CashflowTokens/CashflowTokens"
import {
  TransferSingle,
  URI,
} from "../generated/schema"

export function handleTransferSingle(event: TransferSingleEvent): void {
  let entity = new TransferSingle(
    event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  )
  entity.operator = event.params.operator
  entity.from = event.params.from
  entity.to = event.params.to
  entity.value = event.params.value
  entity.save()
}

export function handleURI(event: URIEvent): void {
  let entity = new URI(
    event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  )
  entity.value = event.params.value
  entity.save()
}
