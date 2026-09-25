package com.instafoo.Model;

import java.sql.Timestamp;

public class User {

    private int user_id;
    private String username;
    private String password;
    private String email;
    private String role;
    private String address;
    private Timestamp logout;
    private Timestamp create;
    private String security_question;
    private String security_answer;
    private String security_question_2;
    private String security_answer_2;

    public User() {

    }

    public User(String username, String password, String email,
                String role, String address, Timestamp logout) {

        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
        this.address = address;
        this.logout = logout;
    }

    public User(int user_id, String username, String password,
                String email, String role, String address,
                Timestamp logout, Timestamp create) {

        this.user_id = user_id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
        this.address = address;
        this.logout = logout;
        this.create = create;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Timestamp getLogout() {
        return logout;
    }

    public void setLogout(Timestamp logout) {
        this.logout = logout;
    }

    public Timestamp getCreate() {
        return create;
    }

    public void setCreate(Timestamp create) {
        this.create = create;
    }

    public String getSecurity_question() {
        return security_question;
    }

    public void setSecurity_question(String security_question) {
        this.security_question = security_question;
    }

    public String getSecurity_answer() {
        return security_answer;
    }

    public void setSecurity_answer(String security_answer) {
        this.security_answer = security_answer;
    }

    public String getSecurity_question_2() {
        return security_question_2;
    }

    public void setSecurity_question_2(String security_question_2) {
        this.security_question_2 = security_question_2;
    }

    public String getSecurity_answer_2() {
        return security_answer_2;
    }

    public void setSecurity_answer_2(String security_answer_2) {
        this.security_answer_2 = security_answer_2;
    }

    @Override
    public String toString() {
        return "User [user_id=" + user_id
                + ", username=" + username
                + ", password=" + password
                + ", email=" + email
                + ", role=" + role
                + ", address=" + address
                + ", logout=" + logout
                + ", create=" + create 
                + ", security_question=" + security_question 
                + ", security_answer=" + security_answer 
                + ", security_question_2=" + security_question_2 
                + ", security_answer_2=" + security_answer_2 + "]";
    }
}