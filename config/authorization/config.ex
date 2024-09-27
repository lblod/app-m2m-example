
alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec.Constraint.ResourceFormat, as: ResourceFormatConstraint
alias Acl.Accessibility.ByQuery, as: AccessByQuery
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  defp logged_in_app() do
    %AccessByQuery{
      vars: [],
      query: "PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
      PREFIX session: <http://mu.semte.ch/vocabularies/session/>
      PREFIX ext: <http://mu.semte.ch/vocabularies/ext/>
      PREFIX dcterms: <http://purl.org/dc/terms/>
      SELECT DISTINCT ?account WHERE {
      <SESSION_ID> session:account ?account;
                   ext:applicationName \"test-nordine\";
                   ext:exp ?exp.
      values ?epoch { \"1970-01-01T00:00:00\"^^xsd:dateTime }
      BIND(ROUND(NOW() - ?epoch ) AS ?current_time)
      FILTER(?exp > ?current_time)

      }"
    }
  end
  def user_groups do
    [            
      %GroupSpec{
        name: "mow-app",
        useage: [:read, :write, :read_for_write],
        access: logged_in_app(),
        graphs: [ %GraphSpec{
                    graph: "http://bittich.be/AppGraphProtected",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://bittich.be/AppDataProtected"
                      ] } } ] },
      %GroupSpec{
        name: "public",
        useage: [:read],
        access: %AlwaysAccessible{},
        graphs: [        
          %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/public",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://data.vlaanderen.be/ns/besluit#Bestuurseenheid"
                      ]
                    } } ] },

      # CLEANUP
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [:read, :write],
        name: "clean"
      }
    ]
  end
end
