defmodule PlateSlateWeb.Resolvers.Category do
  alias PlateSlate.Menu

  def categoryies(_, args, _) do
    {:ok, Menu.list_categories(args)}
  end
end
