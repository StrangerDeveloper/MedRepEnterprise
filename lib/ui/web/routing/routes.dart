const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";

const productPageDisplayName = "Products";
const productPageRoute = "/productList";

const staffPageDisplayName = "Bookers";
const staffPageRoute = "/staffList";

const clientPageDisplayName = "Customers";
const clientsPageRoute = "/clientList";

const areaPageDisplayName = "Areas";
const areasPageRoute = "/areasList";

const orderPageDisplayName = "Orders History";
const orderPageRoute = "/orderHistoryList";

const profilePageDisplayName = "Profile";
const profilePageRoute = "/profile";

const authenticationPageDisplayName = "Log out";
const authenticationPageRoute = "/auth";

const splashPageDisplayName = "Splash ";
const splashPageRoute = "/splash";
class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

List<MenuItem> sideMenuItemRoutes = [
  MenuItem(overviewPageDisplayName, overviewPageRoute),
  MenuItem(areaPageDisplayName, areasPageRoute),
  MenuItem(clientPageDisplayName, clientsPageRoute),
  MenuItem(orderPageDisplayName, orderPageRoute),
  MenuItem(productPageDisplayName, productPageRoute),
  MenuItem(staffPageDisplayName, staffPageRoute),
  MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];


