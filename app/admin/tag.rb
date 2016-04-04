ActiveAdmin.register Tag do
  menu parent: "Events", priority: 200

  actions :all

  permit_params :name, :tag_type, :tag_category

  config.sort_order = "lower(name) asc"

  filter :name
  filter :tag_type, as: :select, collection: TagTypes.all
  filter :tag_category, as: :select, collection: TagCategories.all

  index do
    column :name
    column :tag_type
    column :tag_category
    column :updated_at
    column :created_at
    actions
  end
end