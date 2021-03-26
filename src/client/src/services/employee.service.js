import spmsAPI from "../apis/spms-erp";
import authHeader from "./auth.header";

export function getAll() {
  return spmsAPI.get("/employees", { headers: authHeader() });
}

export function getOne(id) {
  return spmsAPI.get(`/employees/${id}`, { headers: authHeader() });
}
