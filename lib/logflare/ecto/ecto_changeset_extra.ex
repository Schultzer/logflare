defmodule Logflare.EctoChangesetExtras do
  import Logflare.EctoSchemaReflection, only: [fields_no_embeds: 1]

  def cast_all_fields(struct, attrs) do
    Ecto.Changeset.cast(struct, attrs, fields_no_embeds(struct.__struct__))
  end
end
