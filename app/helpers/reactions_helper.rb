module ReactionsHelper
  # Structクラスを使って、リアクションの表示情報をまとめる
  ReactionView = Struct.new(:existing, :active, :count, keyword_init: true)

  def reaction_view(reactable, user, kind)
    rel = reactable.reactions

    # 未ログイン時
    return ReactionView.new(existing: nil, active: false, count: rel.where(kind: kind).count) unless user

    existing = rel.find_by(user:, kind:)
    active   = existing.present?
    count    = rel.where(kind: kind).count

    ReactionView.new(existing:, active:, count:)
  end
end
