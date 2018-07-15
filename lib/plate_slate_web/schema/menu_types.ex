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
    field(:priced_above, :float)

    @desc "Priced below a value"
    field(:priced_below, :float)

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
    field(:price, :float)

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
end
