defmodule PlateSlateWeb.Schema.MenuTypes do
  use Absinthe.Schema.Notation
  alias PlateSlateWeb.Resolvers

  # menu item
  object :menu_queries do
    field :menu_items, list_of(:menu_item) do
      arg(:filter, non_null(:menu_item_filter))
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(&Resolvers.Menu.menu_items/3)
    end
  end

  @desc "Filtering options for the menu item list"
  input_object(:menu_item_filter) do
    @desc "Matching a name"
    field(:name, :string)

    @desc "Matching a category name"
    field(:category, :string)

    @desc "Matching a tag"
    field(:tag, :string)

    @desc "Priced above a value"
    field(:priced_above, :decimal)

    @desc "Priced below a value"
    field(:priced_below, :decimal)

    @desc "Added to the menu before this date"
    field(:added_before, :date)

    @desc "Added to the menu after this date"
    field(:added_after, :date)
  end

  @desc "single menu item object"
  object :menu_item do
    interfaces([:search_result])
    @desc "id of menu item"
    field(:id, :id)

    @desc "name of item"
    field(:name, :string)

    @desc "description of item"
    field(:description, :string)

    @desc "price of item"
    field(:price, :decimal)

    @desc "item added on this date"
    field(:added_on, :date)
  end

  # category
  object :category do
    interfaces([:search_result])
    field(:name, :string)
    field(:description, :string)

    field :items, list_of(:menu_item) do
      resolve(&Resolvers.Menu.items_for_category/3)
    end
  end

  interface :search_result do
    field(:name, :string)

    resolve_type(fn
      %PlateSlate.Menu.Item{}, _ ->
        :menu_item

      %PlateSlate.Menu.Category{}, _ ->
        :category

      _, _ ->
        nil
    end)
  end

  input_object(:menu_item_input) do
    field(:name, non_null(:string))
    field(:description, :string)
    field(:price, non_null(:decimal))
    field(:category_id, non_null(:id))
  end

  input_object(:menu_item_update_input) do
    field(:name, non_null(:string))
    field(:description, :string)
    field(:price, :decimal)
  end

  object :menu_item_result do
    field(:menu_item, :menu_item)
    field(:errors, list_of(:input_error))
  end
end
