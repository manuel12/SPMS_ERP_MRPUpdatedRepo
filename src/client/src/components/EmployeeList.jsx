import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
// import spmsAPI from "../apis/spms-erp";
import MUIDataTable from "mui-datatables";
import { getAll } from "../services/employee.service";

// material ui imports
import { IconButton } from "@mui/material";

// material ui icons
import { Edit } from "@mui/icons-material";

const EmployeeList = () => {
  const [employees, setEmployees] = useState([]);
  const [message, setMessage] = useState("");

  const Navigate = useNavigate();

  const muiDataTablesColumns = [
    {
      name: "edit",
      label: " ",
      options: {
        filter: false,
        sort: false,
        empty: true,
        viewColumns: false,
        customBodyRenderLite: (dataIndex, rowIndex) => {
          return (
            <IconButton
              onClick={() =>
                Navigate.push(`/employees/${employees[dataIndex].id}`)
              }
            >
              <Edit />
            </IconButton>
          );
        },
      },
    },
    { label: "ID", name: "id" },
    { label: "Firstname", name: "firstname" },
    { label: "Lastname", name: "lastname" },
    { label: "Phone", name: "phone" },
    { label: "Cell", name: "cell" },
    { label: "Email", name: "email" },
    { label: "D.O.B", name: "dob" },
    { label: "Notes", name: "notes" },
    { label: "Department", name: "department_name" },
    { label: "Job Title", name: "title" },
  ];

  const onRowClickHandler = (rowData, rowMeta) =>
    Navigate.push(`/employees/${rowData[0]}`);

  const muiDataTablesOptions = {
    filter: false,
    // select single rows only by click
    selectableRows: "single",
    selectableRowsHideCheckboxes: true,
    selectableRowsOnClick: true,
    // do not show select toolbar, which has a delete action
    selectToolbarPlacement: "none",
  };

  // retrieve employees when component mounts
  useEffect(() => {
    getAll()
      .then((response) => {
        setEmployees(() => response.data.recordset);
      })
      .catch((error) => {
        const errMsg =
          (error.response &&
            error.response.data &&
            error.response.data.message) ||
          error.message ||
          error.toString();

        setMessage(errMsg);
      });
  }, []);

  return (
    <>
      <div>
        <MUIDataTable
          title="Employees"
          columns={muiDataTablesColumns}
          data={employees}
          options={muiDataTablesOptions}
        />
      </div>
      {message && <p>{message}</p>}
    </>
  );
};

export default EmployeeList;
