// src/main/java/com/economiangola/repository/NotificacaoRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Notificacao;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificacaoRepository extends JpaRepository<Notificacao, Long> {

    Page<Notificacao> findByUsuarioIdOrderByCriadoEmDesc(Long usuarioId, Pageable pageable);

    long countByUsuarioIdAndLidaFalse(Long usuarioId);

    @Modifying
    @Query("UPDATE Notificacao n SET n.lida = true, n.lidaEm = CURRENT_TIMESTAMP WHERE n.usuario.id = :usuarioId AND n.lida = false")
    void marcarTodasComoLidas(@Param("usuarioId") Long usuarioId);
}
