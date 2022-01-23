defmodule Fade.Diagnostic.KnowledgeBase do
  alias Fade.Diagnostic.Types.KnowledgeBaseArticle

  @callback get_article!(id :: String.t(), status :: atom()) :: KnowledgeBaseArticle.t()
end
