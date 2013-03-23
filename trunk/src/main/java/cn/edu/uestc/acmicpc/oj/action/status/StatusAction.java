/*
 * cdoj, UESTC ACMICPC Online Judge
 * Copyright (c) 2013 fish <@link lyhypacm@gmail.com>,mzry1992 <@link muziriyun@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package cn.edu.uestc.acmicpc.oj.action.status;

import cn.edu.uestc.acmicpc.db.condition.base.Condition;
import cn.edu.uestc.acmicpc.db.condition.impl.StatusCondition;
import cn.edu.uestc.acmicpc.db.dao.iface.IStatusDAO;
import cn.edu.uestc.acmicpc.db.entity.Status;
import cn.edu.uestc.acmicpc.db.view.impl.StatusView;
import cn.edu.uestc.acmicpc.ioc.condition.StatusConditionAware;
import cn.edu.uestc.acmicpc.ioc.dao.StatusDAOAware;
import cn.edu.uestc.acmicpc.oj.action.BaseAction;
import cn.edu.uestc.acmicpc.oj.view.PageInfo;
import cn.edu.uestc.acmicpc.util.annotation.LoginPermit;
import cn.edu.uestc.acmicpc.util.exception.AppException;
import org.apache.struts2.interceptor.validation.SkipValidation;

import java.util.ArrayList;
import java.util.List;

/**
 * Action for list and search all submit status
 *
 * @author <a href="mailto:muziriyun@gmail.com">mzry1992</a>
 */
@LoginPermit(NeedLogin = false)
public class StatusAction extends BaseAction
        implements StatusConditionAware, StatusDAOAware {

    @SkipValidation
    public String toStatusList() {
        return SUCCESS;
    }

    /**
     * StatusDAO for status queries.
     */
    private IStatusDAO statusDAO;
    private StatusCondition statusCondition;

    /**
     * Search action.
     * <p/>
     * Find all records by conditions and return them as a list in JSON, and the condition
     * set will set in JSON named "condition".
     * <p/>
     * <strong>JSON output</strong>:
     * <ul>
     * <li>
     * For success: {"result":"ok", "pageInfo":<strong>PageInfo object</strong>,
     * "condition", <strong>ProblemCondition entity</strong>,
     * "problemList":<strong>query result</strong>}
     * </li>
     * <li>
     * For error: {"result":"error", "error_msg":<strong>error message</strong>}
     * </li>
     * </ul>
     *
     * @return <strong>JSON</strong> signal
     */
    @SkipValidation
    public String toSearch() {
        try {
            Condition condition = statusCondition.getCondition();
            Long count = statusDAO.count(statusCondition.getCondition());
            PageInfo pageInfo = buildPageInfo(count, RECORD_PER_PAGE, "", null);
            condition.currentPage = pageInfo.getCurrentPage();
            condition.countPerPage = RECORD_PER_PAGE;
            List<Status> statusList = statusDAO.findAll(condition);
            List<StatusView> statusViewList = new ArrayList<>();
            for (Status status : statusList)
                statusViewList.add(new StatusView(status));
            json.put("pageInfo", pageInfo.getHtmlString());
            json.put("result", "ok");
            json.put("condition", statusCondition);
            json.put("problemList", statusViewList);
        } catch (AppException e) {
            json.put("result", "error");
            json.put("error_msg", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            json.put("result", "error");
            json.put("error_msg", "Unknown exception occurred.");
        }
        return JSON;
    }

    @Override
    public void setStatusCondition(StatusCondition statusCondition) {
        this.statusCondition = statusCondition;
    }

    @Override
    public void setStatusDAO(IStatusDAO statusDAO) {
        this.statusDAO = statusDAO;
    }
}