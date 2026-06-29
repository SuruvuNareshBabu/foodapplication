package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Restaurant;
import service.RestaurantService;

@WebServlet("/restaurant")
public class RestaurantController extends HttpServlet {

    private RestaurantService restaurantService;

    @Override
    public void init() {

        restaurantService = new RestaurantService();

    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Restaurant> restaurants =
                restaurantService.getAllRestaurants();

        

        request.setAttribute("restaurants", restaurants);

        request.getRequestDispatcher("restaurant.jsp")
                .forward(request, response);

    }

}