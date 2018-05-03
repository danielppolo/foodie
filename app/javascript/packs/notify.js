import swal from 'sweetalert';
swal ( "The order has been placed!" ,  "Your meal will be waiting for you!" ,  "success" )

document.getElementById('cancel-order').addEventListener('click', function {
  swal ( "Order canceled!" ,  "The order has been canceled" ,  "success" )
});
