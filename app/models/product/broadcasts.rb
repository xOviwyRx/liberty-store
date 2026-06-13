module Product::Broadcasts
  extend ActiveSupport::Concern

  included do
    after_update_commit :broadcast_inventory_update, if: :saved_change_to_inventory_count?
  end

  private

  def broadcast_inventory_update
    broadcast_replace_later_to self,
      target: ActionView::RecordIdentifier.dom_id(self, :inventory),
      partial: "products/inventory",
      locals: { product: self }

    broadcast_replace_later_to "products",
      target: ActionView::RecordIdentifier.dom_id(self, :card_actions),
      partial: "products/card_actions",
      locals: { product: self }
  end
end
