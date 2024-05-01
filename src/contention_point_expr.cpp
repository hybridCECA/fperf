// contention_point_expr.cpp

#include "contention_point_expr.hpp"

expr get_expr2(ContentionPoint& cp, Query& query) {
    cid_t id = get<cid_t>(query.get_lhs());
    Metric* metric = cp.metrics[query.get_metric()][id];

    expr_vector queries(cp.net_ctx.z3_ctx());
    time_range_t range = query.get_time_range();
    for (unsigned int time = range.first; time <= range.second; time++) {
        expr_vector valid(cp.net_ctx.z3_ctx());

        m_val_expr_t val = metric->val(time);
        valid.push_back(val.first);

        queries.push_back(mk_and(valid) && cp.mk_op(val.second,
            query.get_op(),
            cp.net_ctx.int_val(query.get_thresh())));
    }

    return mk_and(queries);
}
