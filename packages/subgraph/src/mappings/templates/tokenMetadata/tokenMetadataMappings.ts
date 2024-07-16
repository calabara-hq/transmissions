import { json, Bytes, dataSource } from '@graphprotocol/graph-ts'
import { TokenMetadata } from '../../../generated/schema'
import { log } from 'matchstick-as'

export function handleTokenMetadata(content: Bytes): void {

    log.info('handleTokenMetadata', [])
    let tokenMetadata = new TokenMetadata(dataSource.stringParam())

    const value = json.fromBytes(content).toObject()
    if (value) {
        const name = value.get('name')
        const description = value.get('description')
        const image = value.get('image')
        const animation = value.get('animation')
        const type = value.get('type')

        tokenMetadata.name = name ? name.toString() : ""
        tokenMetadata.description = description ? description.toString() : ""
        tokenMetadata.image = image ? image.toString() : ""
        tokenMetadata.animation = animation ? animation.toString() : ""
        tokenMetadata.type = type ? type.toString() : ""

        tokenMetadata.save()
    }
}
