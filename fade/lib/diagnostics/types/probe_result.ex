defmodule Fade.Diagnostic.Types.ProbeResult do
  use TypedStruct

  alias Fade.Diagnostic.Types.{KnowledgeBaseArticle, ProbeData}

  typedstruct do
    field(:parent_component_id, String.t())
    field(:component_id, String.t())

    field(
      :component_type,
      :connection
      | :channel
      | :queue
      | :node
      | :disk
      | :memory
      | :runtime
      | :operating_system
      | :exchange
      | :na
    )

    field(:id, String.t())
    field(:name, String.t())
    field(:status, :unhealthy | :healthy | :warning | :inconclusive | :na)
    field(:kb_article, KnowledgeBaseArticle.t())
    field(:data, list(ProbeData))
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end

    def not_applicable(
          parent_component_id,
          component_id,
          probe_id,
          name,
          component_type,
          kb_article
        ) do
      probe_status(
        parent_component_id,
        component_id,
        probe_id,
        name,
        component_type,
        nil,
        :na,
        kb_article
      )
    end

    def warning(
          parent_component_id,
          component_id,
          probe_id,
          name,
          component_type,
          probe_data,
          kb_article
        ) do
      probe_status(
        parent_component_id,
        component_id,
        probe_id,
        name,
        component_type,
        probe_data,
        :warning,
        kb_article
      )
    end

    def healthy(
          parent_component_id,
          component_id,
          probe_id,
          name,
          component_type,
          probe_data,
          kb_article
        ) do
      probe_status(
        parent_component_id,
        component_id,
        probe_id,
        name,
        component_type,
        probe_data,
        :healthy,
        kb_article
      )
    end

    def unhealthy(
          parent_component_id,
          component_id,
          probe_id,
          name,
          component_type,
          probe_data,
          kb_article
        ) do
      probe_status(
        parent_component_id,
        component_id,
        probe_id,
        name,
        component_type,
        probe_data,
        :unhealthy,
        kb_article
      )
    end

    def inconclusive(
          parent_component_id,
          component_id,
          probe_id,
          name,
          component_type,
          kb_article
        ) do
      probe_status(
        parent_component_id,
        component_id,
        probe_id,
        name,
        component_type,
        nil,
        :inconclusive,
        kb_article
      )
    end

    defp probe_status(
           parent_component_id,
           component_id,
           probe_id,
           name,
           component_type,
           probe_data,
           status,
           kb_article
         ) do
      new(
        parent_component_id: parent_component_id,
        component_id: component_id,
        component_type: component_type,
        id: probe_id,
        name: name,
        status: status,
        kb_article: kb_article,
        data: probe_data,
        timestamp: DateTime.utc_now()
      )
    end
  end
end
