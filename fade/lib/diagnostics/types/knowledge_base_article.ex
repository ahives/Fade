defmodule Fade.Diagnostic.Types.KnowledgeBaseArticle do
  use TypedStruct

  typedstruct do
    field(:id, String.t())
    field(:status, :unhealthy | :healthy | :warning | :inconclusive | :na)
    field(:reason, String.t())
    field(:remediation, String.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
