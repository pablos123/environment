"""Bad implementation of the Christofides Algorithm"""

from graph_tool import EdgePropertyMap, VertexPropertyMap
from graph_tool.all import (
    Graph,
    extract_largest_component,
    max_cardinality_matching,
    min_spanning_tree,
    sfdp_layout,
    graph_draw,
)
from random import randrange
from math import sqrt


def draw(g: Graph, c: EdgePropertyMap) -> None:
    assert g is not None
    pos = sfdp_layout(g=g, cooling_step=0.5, epsilon=1e-2)
    graph_draw(g=g, edge_text=c, pos=pos, edge_font_size=20, vertex_size=20)


def christofides_algorithm(n):
    # Generate a complete euclidean graph
    g: Graph = Graph(directed=False)
    random_points = []
    for i in range(n):
        random_points.append((randrange(0, 2 * n), randrange(0, 2 * n)))

    costs: EdgePropertyMap = g.new_edge_property("double")
    for i in range(n):
        for j in range(i + 1, n):
            e = g.add_edge(i, j, add_missing=True)
            cost = sqrt(
                (random_points[j][0] - random_points[i][0]) ** 2
                + (random_points[j][1] - random_points[i][1]) ** 2
            )
            costs[e] = cost

    g.edge_properties["costs"] = costs

    # Create a minimal spanning tree
    gT: Graph = g.copy()
    edge_prop: EdgePropertyMap = min_spanning_tree(
        g=gT, weights=gT.edge_properties["costs"]
    )
    gT.set_edge_filter(edge_prop)
    gT.purge_edges()
    gT.purge_vertices()

    # Get the subgraph of Kn induced by the odd vertices in the minimal spanning tree
    odd_vert_subgraph: Graph = g.copy()
    odd_vert_prop: VertexPropertyMap = odd_vert_subgraph.new_vertex_property("bool")
    for v in gT.vertices():
        odd_vert_prop[v] = bool(len(gT.get_all_neighbors(v)) % 2)
    odd_vert_subgraph.set_vertex_filter(odd_vert_prop)

    # Get the subgraph of the minimal matching in the odd_vert_subgraph
    minimal_matching_graph: Graph = odd_vert_subgraph.copy()
    minimal_matching_edges_prop: EdgePropertyMap = max_cardinality_matching(
        minimal_matching_graph,
        weight=minimal_matching_graph.edge_properties["costs"],
        minimize=True,
        edges=True,
    )
    minimal_matching_graph.set_edge_filter(minimal_matching_edges_prop)

    # My union because the library does not work well with a multiset.
    iteration_graph: Graph = gT.copy()
    for e in minimal_matching_graph.edges():
        new_e = iteration_graph.add_edge(source=e.source(), target=e.target())
        iteration_graph.edge_properties["costs"][new_e] = (
            minimal_matching_graph.edge_properties["costs"][e]
        )

    draw(g=g, c=g.edge_properties["costs"])
    draw(g=gT, c=gT.edge_properties["costs"])
    draw(
        g=odd_vert_subgraph,
        c=odd_vert_subgraph.edge_properties["costs"],
    )
    draw(
        g=minimal_matching_graph,
        c=minimal_matching_graph.edge_properties["costs"],
    )

    # Iterate until you do not have vertices with dr > 2
    def needs_iteration() -> bool:
        for v in iteration_graph.vertices():
            if v.out_degree() > 2:
                return True
        return False

    while needs_iteration():
        vertice1 = None
        vertice2 = None
        for v in iteration_graph.vertices():
            if v.out_degree() == 2:
                continue

            # Check if the graph is connected when removing two edges
            found = False
            for v1 in v.all_neighbors():
                for v2 in v.all_neighbors():
                    if v1 == v2:
                        continue
                    check_connected = iteration_graph.copy()
                    check_connected.remove_edge(check_connected.edge(v, v1))
                    check_connected.remove_edge(check_connected.edge(v, v2))
                    if len(
                        extract_largest_component(
                            check_connected, prune=True
                        ).get_vertices()
                    ) == len(iteration_graph.get_vertices()):
                        vertice1 = v1
                        vertice2 = v2
                        found = True
                        break
                if found:
                    break

            assert vertice1 and vertice2

            new_e = iteration_graph.add_edge(vertice1, vertice2)
            iteration_graph.edge_properties["costs"][new_e] = g.edge_properties[
                "costs"
            ][new_e]

            iteration_graph.remove_edge(iteration_graph.edge(v, vertice1))
            iteration_graph.remove_edge(iteration_graph.edge(v, vertice2))

            draw(
                g=iteration_graph,
                c=iteration_graph.edge_properties["costs"],
            )

    iteration_graph.purge_edges()
    iteration_graph.purge_vertices()
    ret = 0
    for e in iteration_graph.edges():
        ret += iteration_graph.edge_properties["costs"][e]

    print(f"Final cost: {ret}")


if __name__ == "__main__":
    christofides_algorithm(20)
